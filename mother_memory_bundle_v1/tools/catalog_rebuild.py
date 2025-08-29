#!/usr/bin/env python3
import json, hashlib, os, sys, time

FILES = [
  "memory_core.json","ui.json","hardware.json","projects.json",
  "output_pipeline.json","references.json","catalog.json"
]

def sha256(path):
    h=hashlib.sha256()
    with open(path,'rb') as f:
        for chunk in iter(lambda: f.read(1024*1024), b""):
            h.update(chunk)
    return h.hexdigest()

def main():
    missing = [f for f in FILES if not os.path.exists(f)]
    if missing:
        print("Missing files:", ", ".join(missing))
        sys.exit(1)

    catalog = {
      "name": "chronovolt_memory_core_catalog",
      "generated_utc": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime() ),
      "modules": {},
      "source_files": {}
    }
    for f in FILES:
        catalog["modules"][f] = {
          "path": f,
          "bytes": os.path.getsize(f),
          "sha256": sha256(f)
        }

    with open("catalog.json","w",encoding="utf-8") as out:
        json.dump(catalog, out, ensure_ascii=False, indent=2)
    print("catalog.json updated.")

if __name__ == "__main__":
    main()