#!/bin/bash
virsh list --state-shutoff --name | xargs -i virsh start {}