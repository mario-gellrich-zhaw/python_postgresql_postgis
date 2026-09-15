#!/usr/bin/env bash
# Starts the Compose stack and restores forwarding for the Compose bridge when
# a stale iptables-legacy FORWARD policy overrides Docker's nftables rules.
set -e

cd "$(dirname "$0")/.."

docker compose up -d

if command -v iptables-legacy >/dev/null 2>&1; then
  while read -r bridge; do
    if [ -n "$bridge" ] && ! ip link show "$bridge" >/dev/null 2>&1; then
      sudo iptables-legacy -S FORWARD | grep -- "$bridge" | sed 's/^-A/-D/' | while read -r rule; do
        sudo iptables-legacy $rule 2>/dev/null \
          && echo "Removed stale forwarding rule for gone bridge $bridge"
      done
    fi
  done < <(sudo iptables-legacy -S FORWARD | grep -oE 'br-[0-9a-f]+' | sort -u)

  container_id=$(docker compose ps -q db 2>/dev/null || true)
  if [ -n "$container_id" ]; then
    network_name=$(docker inspect "$container_id" --format '{{range $name, $network := .NetworkSettings.Networks}}{{$name}}{{end}}' 2>/dev/null || true)
    if [ -n "$network_name" ]; then
      network_id=$(docker network inspect "$network_name" -f '{{.Id}}' 2>/dev/null | cut -c1-12 || true)
      if [ -n "$network_id" ]; then
        bridge="br-$network_id"
        if ip link show "$bridge" >/dev/null 2>&1; then
          add_rule() {
            if ! sudo iptables-legacy -C FORWARD "$@" -j ACCEPT 2>/dev/null; then
              sudo iptables-legacy -I FORWARD "$@" -j ACCEPT 2>/dev/null \
                && echo "Added missing forwarding rule for $bridge: $*" \
                || echo "Warning: could not add iptables rule for $bridge: $*"
            fi
          }
          add_rule -o "$bridge" -m conntrack --ctstate RELATED,ESTABLISHED
          add_rule -i "$bridge" ! -o "$bridge"
          add_rule -i "$bridge" -o "$bridge"
        fi
      fi
    fi
  fi
fi