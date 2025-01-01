Received: from mail.3xo.fr (mail.3xo.fr [212.129.21.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B14E3433AB
	for <linux-cifs@vger.kernel.org>; Wed,  1 Jan 2025 18:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.129.21.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735754466; cv=none; b=YxsHsMjaqaaWF2ZRByTIx5QuxyvOabuVGam8zq4s/upnQCzYBrTR4H711FcIadxJOMozeXv1nC8awmS26jz2LAQG7/yoyFcFdsWC2MR50CjssUqF7bHp/ztBVsbp8vOFawIFk3bwAwDy8/me1dJ0UpE8pdLIU+xRssUHdBHVO9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735754466; c=relaxed/simple;
	bh=+MjE9XKSNuX7Ir7olokeuFGV39pA/QVWL3IYxl5FI3w=;
	h=MIME-Version:Date:From:To:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=cMkTQEnKmpmEAkQ2+K9Q6ZJLFI9sYxdMEBF5rlDgQ2XwqcK+Vm6AxZ7oivXBXm/KMhliMCBn2uuw9Y8BKGjEincqIHcdZMukk0xAssQUJ5RkuL3tp1vvqFVWDk8XdNlIxigfWc2w3N7UkXjFeGcIw3fOWwTpcDbPCogIkiny3u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=3xo.fr; spf=pass smtp.mailfrom=3xo.fr; dkim=pass (2048-bit key) header.d=3xo.fr header.i=@3xo.fr header.b=2v776x9o; arc=none smtp.client-ip=212.129.21.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=3xo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=3xo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=3xo.fr header.i=@3xo.fr header.b="2v776x9o"
Received: from localhost (mail.3xo.fr [212.129.21.66])
	by mail.3xo.fr (Postfix) with ESMTP id E6B2E59;
	Wed,  1 Jan 2025 19:01:00 +0100 (CET)
X-Virus-Scanned: Debian amavis at nxo2.3xo.fr
Received: from mail.3xo.fr ([212.129.21.66])
 by localhost (mail.3xo.fr [212.129.21.66]) (amavis, port 10024) with ESMTP
 id PjnpJgR9d-Gu; Wed,  1 Jan 2025 19:00:58 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.3xo.fr 73BA62F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=3xo.fr; s=3xo;
	t=1735754458; bh=VVxzXEt4fL/5UYis9WbtA+tTqRrdu/XF46crhmpEVzg=;
	h=Date:From:To:Subject:In-Reply-To:References:From;
	b=2v776x9ouczIyjLdFIFTM27nI+wClDoFsV9JVHjMajitfOQjrtJkbzkYFhv4bknv8
	 jDjC9+CkcN7dMM5PrH4xhJS8fvuvMfPK25F9/IOs7s96q+A3tmmJNGKAp8YzCcwljy
	 H9YGoaSQfNhL7nruRycdDwRJVtOLARZX6elonik/Z8MF1kxK7NXpbQwL7ZwsRVemEr
	 FCIGHPSvE9nhOQwbN61f/6X7hpg6JblkyyEZDIMSjPdYgIImGojuDjuyDcEfuE1isz
	 mLnsNwp5yE2ywMeAsdagFahfFqaPM8oiDD6G3GuSj4M1PBs/Vrfn390azQbbaCk4wv
	 QGQwqvV85ZVqw==
Received: from mail.3xo.fr (mail.3xo.fr [212.129.21.66])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.3xo.fr (Postfix) with ESMTPSA id 73BA62F;
	Wed,  1 Jan 2025 19:00:58 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 01 Jan 2025 19:00:58 +0100
From: nicolas.baranger@3xo.fr
To: linux-cifs@vger.kernel.org, netfs@lists.linux.dev
Subject: Re: Losetup Direct I/O breaks BACK-FILE filesystem on CIFS share
 (Appears in Linux 6.10 and reproduced on mainline)
In-Reply-To: <669f22fc89e45dd4e56d75876dc8f2bf@3xo.fr>
References: <669f22fc89e45dd4e56d75876dc8f2bf@3xo.fr>
Message-ID: <fedd8a40d54b2969097ffa4507979858@3xo.fr>
X-Sender: nicolas.baranger@3xo.fr
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit


Dear mainteners

Don't know if it's the right place to contact kernel developers but 
today I did report the following bug which appears in Linux 6.10 and I'm 
able to reproduce from Linux 6.10 to mainline

I think the new way CIFS is using NETFS could be one of the cause of the 
issue, as doing :

git log --pretty=oneline v6.9.12..v6.10 | grep cifs: | grep netfs
return :
3ee1a1fc39819906f04d6c62c180e760cd3a689d cifs: Cut over to using 
netfslib
69c3c023af25edb5433a2db824d3e7cc328f0183 cifs: Implement netfslib hooks
dc5939de82f149633d6ec1c403003538442ec9ef cifs: Replace the writedata 
replay bool with a netfs sreq flag
ab58fbdeebc7f9fe8b9bc202660eae3a10e5e678 cifs: Use more fields from 
netfs_io_subrequest
a975a2f22cdce7ec0c678ce8d73d2f6616cb281c cifs: Replace cifs_writedata 
with a wrapper around netfs_io_subrequest
753b67eb630db34e36ec4ae1e86c75e243ea4fc9 cifs: Replace cifs_readdata 
with a wrapper around netfs_io_subrequest


The BUG ID is : https://bugzilla.kernel.org/show_bug.cgi?id=219648

Content of #219648 bug:

Dear maintener,

Since I upgrade 1 server from Linux 6.9.12 to Linux 6.10, I encountered 
the following problem :

Backups of one server are made by writing a dd copy of each LVM volumes 
snapshots into a BACK FILE (LUKS + BTRFS formated) which reside on a big 
SAMBA share (SMB 3.1.1).

The BACK FILE is mounted on the server using 'losetup --sector-size 4096 
--direct-io=on /dev/loop2046 /path/to/back-file/on/samba/share'

It has work very fine since years and years and this methode is it still 
working on the same share ( and different back-files ) from other 
servers using respectively Linux 6.1.25 and Linux 6.5.10 and Linux 
6.9.12

But since I update kernel to Linux  6.10, when I mount the BACK-FILE, at 
the first write the BACK-FILE becomes read-only  and I have this error 
in kernel logs :

[lun. 23 déc. 10:08:49 2024] loop2046: detected capacity change from 0 
to 8589934592
[lun. 23 déc. 10:08:51 2024] BTRFS: device fsid 
a2c979e6-2c6e-4308-a238-55e417a3bcd9 devid 1 transid 395 
/dev/mapper/bckcrypt (253:30) scanned by mount (3643571)
[lun. 23 déc. 10:08:51 2024] BTRFS info (device dm-30): first mount of 
filesystem a2c979e6-2c6e-4308-a238-55e417a3bcd9
[lun. 23 déc. 10:08:51 2024] BTRFS info (device dm-30): using crc32c 
(crc32c-intel) checksum algorithm
[lun. 23 déc. 10:08:51 2024] BTRFS info (device dm-30): disk space 
caching is enabled
[lun. 23 déc. 10:08:51 2024] BTRFS warning (device dm-30): space cache 
v1 is being deprecated and will be removed in a future release, please 
use -o space_cache=v2
[lun. 23 déc. 10:08:51 2024] BTRFS info (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 15, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] blk_print_req_error: 62 callbacks 
suppressed
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014676032 
op 0x1:(WRITE) flags 0x8800 phys_seg 6 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014675776 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014688456 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014688968 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014689224 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014689736 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014688200 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014689480 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014688712 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] I/O error, dev loop2046, sector 7014690248 
op 0x1:(WRITE) flags 0x8800 phys_seg 2 prio class 0
[lun. 23 déc. 10:08:54 2024] btrfs_dev_stat_inc_and_print: 54 callbacks 
suppressed
[lun. 23 déc. 10:08:54 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 16, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] BTRFS warning (device dm-30): direct IO 
failed ino 361 op 0x8801 offset 0x611000 len 2138112 err no 10
[lun. 23 déc. 10:08:54 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 17, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] BTRFS warning (device dm-30): direct IO 
failed ino 361 op 0x8801 offset 0x81b000 len 2129920 err no 10
[lun. 23 déc. 10:08:54 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 18, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] BTRFS warning (device dm-30): direct IO 
failed ino 361 op 0x8801 offset 0xa23000 len 2088960 err no 10
[lun. 23 déc. 10:08:54 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 19, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] BTRFS warning (device dm-30): direct IO 
failed ino 361 op 0x8801 offset 0x0 len 4190208 err no 10
[lun. 23 déc. 10:08:54 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 20, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:08:54 2024] BTRFS warning (device dm-30): direct IO 
failed ino 361 op 0x8801 offset 0x3ff000 len 2170880 err no 10
[lun. 23 déc. 10:09:24 2024] blk_print_req_error: 82 callbacks 
suppressed
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 183168 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 182912 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 21, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 180864 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 181120 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 22, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 181120 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 180864 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 23, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 180864 op 
0x1:(WRITE) flags 0x800 phys_seg 4 prio class 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 185216 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 24, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 184960 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 25, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] I/O error, dev loop2046, sector 183680 op 
0x1:(WRITE) flags 0x800 phys_seg 2 prio class 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 26, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 27, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:24 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 28, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:25 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 29, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:25 2024] BTRFS error (device dm-30): bdev 
/dev/mapper/bckcrypt errs: wr 30, rd 15, flush 0, corrupt 0, gen 0
[lun. 23 déc. 10:09:25 2024] BTRFS: error (device dm-30) in 
btrfs_commit_transaction:2524: errno=-5 IO failure (Error while writing 
out transaction)
[lun. 23 déc. 10:09:25 2024] BTRFS info (device dm-30 state E): forced 
readonly
[lun. 23 déc. 10:09:25 2024] BTRFS warning (device dm-30 state E): 
Skipping commit of aborted transaction.
[lun. 23 déc. 10:09:25 2024] BTRFS error (device dm-30 state EA): 
Transaction aborted (error -5)
[lun. 23 déc. 10:09:25 2024] BTRFS: error (device dm-30 state EA) in 
cleanup_transaction:2018: errno=-5 IO failure


So First I thought that BTRFS and the fifteen READ / WRITE errors "bdev 
/dev/mapper/bckcrypt errs: wr 15, rd 15" was responsible of the issue, 
so I recreate 100% of the back file on the CIFS share the following way 
:

dd if=/dev/urandom of=/mnt/FBX24T/bck0crypt2044 bs=1G count=4096 
oflag=direct status=progress
losetup --sector-size 4096 --direct-io=on loop2044 
/mnt/FBX24T/bck0crypt2044
cryptsetup luksFormat /dev/loop2044

and normally after (but it didn't work here as the back-file becomes 
read-only)
cryptsetup open /dev/loop2044 bck0crypt2044
mkfs.btrfs /dev/mapper/bck0crypt2044
mount  /dev/mapper/bck0crypt2044 /mnt/bck0crypt

But I cannot do the last part, it breaks at the first write of 
'cryptsetup luksFormat /dev/loop2044'

When testing to directly format the loop device with BTRFS and XFS and 
EXT4, I get the same failiure, ie: at the first write IO the loop device 
become read-only with the provided errors.

So I decide to test again, removing --direct-io=on from losetup command 
and I was able to format with cryptsetup and btrfs (I also tried xfs and 
ext4, all with same result: broken with --direct-io=on and working 
without, same after mounting the loop device whatever filesystem it 
contains)

So this is the  '--direct-io=on' which breaks (from Linux 6.10 to 
mainline) when the back-file is on a CIFS share.
To validate, I did try  '--direct-io=on' on a local filesystem with no 
issue (same process with cryptsetup and brtfs or xfs or ext4)

And to be sure, I did umount the read-only device from the server and 
remove the losetup device too and I go to my Debian 12 laptop with 
kernel 6.9.12 and I mount the CIFS share on which the 'broken' back-file 
reside, creating a loop device (with  '--direct-io=on' ) and I open it 
with cryptsetup and mount it (as previously described).
After that I did issue about 1TB of write from my laptop to this loop 
device with no issues.

One of the biggest problem here removing the '--direct-io=on' from 
losetup command is the read/write performance of the loop device: about 
150Mib/s without '--direct-io=on' (which make it unusable for backuping 
a server every day) and more than 3Gib/s with '--direct-io=on' option.
So with  '--direct-io=on' , the write speed is between 25 to 50 times 
the speed I constat without the option (making this solution viable for 
an 'every day' full backup of 2TB+)

When having a deeper look in the kernel logs, I find that the issue is 
always precede by the following 'netfs:' error:

[mer.  1 janv. 10:58:53 2025] ------------[ cut here ]------------
[mer.  1 janv. 10:58:53 2025] WARNING: CPU: 2 PID: 109 at 
fs/netfs/iterator.c:50 netfs_extract_user_iter+0x170/0x250 [netfs]
[mer.  1 janv. 10:58:53 2025] Modules linked in: dm_crypt(E) cmac(E) 
nls_utf8(E) cifs(E) cifs_arc4(E) nls_ucs2_utils(E) cifs_md4(E) 
dns_resolver(E) netfs(E) snd_seq_dummy(E) snd_hrtimer(E) snd_seq(E) 
snd_seq_device(E) rfkill(E) qrtr(E) binfmt_misc(E) nls_ascii(E) 
nls_cp437(E) vfat(E) fat(E) ext4(E) crc16(E) mbcache(E) jbd2(E) 
intel_rapl_msr(E) intel_rapl_common(E) intel_uncore_frequency_common(E) 
kvm_intel(E) kvm(E) ghash_clmulni_intel(E) sha512_ssse3(E) 
sha256_ssse3(E) sha1_ssse3(E) snd_intel8x0(E) snd_ac97_codec(E) 
ac97_bus(E) aesni_intel(E) crypto_simd(E) cryptd(E) snd_pcm(E) joydev(E) 
rapl(E) snd_timer(E) snd(E) vboxguest(OE) pcspkr(E) soundcore(E) ac(E) 
sg(E) serio_raw(E) evdev(E) msr(E) parport_pc(E) ppdev(E) lp(E) 
parport(E) loop(E) configfs(E) efi_pstore(E) efivarfs(E) ip_tables(E) 
x_tables(E) autofs4(E) btrfs(E) blake2b_generic(E) xor(E) raid6_pq(E) 
libcrc32c(E) crc32c_generic(E) dm_mod(E) hid_generic(E) usbhid(E) hid(E) 
nvme(E) sr_mod(E) cdrom(E) nvme_core(E) t10_pi(E) vmwgfx(E) ahci(E) 
xhci_pci(E) drm_ttm_helper(E)
[mer.  1 janv. 10:58:53 2025]  virtio_net(E) ttm(E) libahci(E) 
net_failover(E) crc64_rocksoft(E) crc32_pclmul(E) drm_kms_helper(E) 
xhci_hcd(E) failover(E) crc64(E) libata(E) crc32c_intel(E) psmouse(E) 
crc_t10dif(E) dimlib(E) crct10dif_generic(E) crct10dif_pclmul(E) 
crct10dif_common(E) scsi_mod(E) usbcore(E) drm(E) scsi_common(E) 
usb_common(E) i2c_piix4(E) video(E) wmi(E) button(E)
[mer.  1 janv. 10:58:53 2025] CPU: 2 PID: 109 Comm: kworker/u35:1 
Tainted: G        W  OE      6.10.0-amd64 #1
[mer.  1 janv. 10:58:53 2025] Hardware name: innotek GmbH 
VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[mer.  1 janv. 10:58:53 2025] Workqueue: loop2046 loop_rootcg_workfn 
[loop]
[mer.  1 janv. 10:58:53 2025] RIP: 
0010:netfs_extract_user_iter+0x170/0x250 [netfs]
[mer.  1 janv. 10:58:53 2025] Code: 00 29 fb 31 ff 89 5a f8 4c 39 d9 75 
c2 4d 85 c9 0f 84 c2 00 00 00 45 39 f2 0f 83 b9 00 00 00 4d 89 cd 44 89 
d3 e9 35 ff ff ff <0f> 0b 48 c7 c3 fb ff ff ff 48 8b 44 24 28 65 48 2b 
04 25 28 00 00
[mer.  1 janv. 10:58:53 2025] RSP: 0018:ffffa44f00887c10 EFLAGS: 
00010202
[mer.  1 janv. 10:58:53 2025] RAX: 0000000000000000 RBX: 
ffff937da084b200 RCX: 0000000000000000
[mer.  1 janv. 10:58:53 2025] RDX: ffff937da084b340 RSI: 
0000000000100000 RDI: ffffa44f00887d10
[mer.  1 janv. 10:58:53 2025] RBP: ffff937da0837920 R08: 
ffffffffc13f7bc0 R09: 0000000000000000
[mer.  1 janv. 10:58:53 2025] R10: ffff937da084b200 R11: 
ffff937b81149100 R12: 0000000000100000
[mer.  1 janv. 10:58:53 2025] R13: ffffa44f00887d10 R14: 
ffffffffc0dbbeb0 R15: 0000034702500000
[mer.  1 janv. 10:58:53 2025] FS:  0000000000000000(0000) 
GS:ffff937e8fb00000(0000) knlGS:0000000000000000
[mer.  1 janv. 10:58:53 2025] CS:  0010 DS: 0000 ES: 0000 CR0: 
0000000080050033
[mer.  1 janv. 10:58:53 2025] CR2: 00007efe292cb9f0 CR3: 
00000001c53f4001 CR4: 00000000000706f0
[mer.  1 janv. 10:58:53 2025] Call Trace:
[mer.  1 janv. 10:58:53 2025]  <TASK>
[mer.  1 janv. 10:58:53 2025]  ? __warn+0x80/0x120
[mer.  1 janv. 10:58:53 2025]  ? netfs_extract_user_iter+0x170/0x250 
[netfs]
[mer.  1 janv. 10:58:53 2025]  ? report_bug+0x164/0x190
[mer.  1 janv. 10:58:53 2025]  ? handle_bug+0x41/0x70
[mer.  1 janv. 10:58:53 2025]  ? exc_invalid_op+0x17/0x70
[mer.  1 janv. 10:58:53 2025]  ? asm_exc_invalid_op+0x1a/0x20
[mer.  1 janv. 10:58:53 2025]  ? __pfx_lo_rw_aio_complete+0x10/0x10 
[loop]
[mer.  1 janv. 10:58:53 2025]  ? netfs_extract_user_iter+0x170/0x250 
[netfs]
[mer.  1 janv. 10:58:53 2025]  ? __pfx_lo_rw_aio_complete+0x10/0x10 
[loop]
[mer.  1 janv. 10:58:53 2025]  
netfs_unbuffered_write_iter_locked+0x97/0x3a0 [netfs]
[mer.  1 janv. 10:58:53 2025]  netfs_unbuffered_write_iter+0x177/0x230 
[netfs]
[mer.  1 janv. 10:58:53 2025]  lo_rw_aio.isra.0+0x2ad/0x2d0 [loop]
[mer.  1 janv. 10:58:53 2025]  loop_process_work+0xae/0x980 [loop]
[mer.  1 janv. 10:58:53 2025]  ? psi_task_switch+0xd6/0x230
[mer.  1 janv. 10:58:53 2025]  ? _raw_spin_unlock+0xe/0x30
[mer.  1 janv. 10:58:53 2025]  ? finish_task_switch.isra.0+0x88/0x2d0
[mer.  1 janv. 10:58:53 2025]  ? __schedule+0x3f3/0xb40
[mer.  1 janv. 10:58:53 2025]  process_one_work+0x17c/0x390
[mer.  1 janv. 10:58:53 2025]  worker_thread+0x265/0x380
[mer.  1 janv. 10:58:53 2025]  ? __pfx_worker_thread+0x10/0x10
[mer.  1 janv. 10:58:53 2025]  kthread+0xd2/0x100
[mer.  1 janv. 10:58:53 2025]  ? __pfx_kthread+0x10/0x10
[mer.  1 janv. 10:58:53 2025]  ret_from_fork+0x34/0x50
[mer.  1 janv. 10:58:53 2025]  ? __pfx_kthread+0x10/0x10
[mer.  1 janv. 10:58:53 2025]  ret_from_fork_asm+0x1a/0x30
[mer.  1 janv. 10:58:53 2025]  </TASK>
[mer.  1 janv. 10:58:53 2025] ---[ end trace 0000000000000000 ]---
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038117888 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038187520 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038185472 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038183424 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038181376 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038179328 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038177280 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038175232 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038173184 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] I/O error, dev loop2046, sector 7038171136 
op 0x1:(WRITE) flags 0x8800 phys_seg 16 prio class 0
[mer.  1 janv. 10:58:53 2025] BTRFS error (device dm-7): bdev 
/dev/mapper/bckcrypt errs: wr 16, rd 15, flush 0, corrupt 0, gen 0
[mer.  1 janv. 10:58:53 2025] BTRFS warning (device dm-7): direct IO 
failed ino 360 op 0x8801 offset 0x0 len 268435456 err no 10


NB: I'm able to reproduce it everytime on Virtual Machines + on physical 
hardware (server, laptop, pc ...) and while trying to bissect the 
regression, I build and test nearly all kernels from Linux 6.9.6 to 
mainline with the exact same result: still working from Linux 6.9.6 to 
6.9.12 and failing from Linux 6.10(.0) to mainline

I'm not a kernel developer but I stay availiable for help or to 
reproduce and give traces of this issue (having now some VM in my lab 
dedicated to build new kernel + to tests and reproduce this particular 
issue, and if needed a public IPv6 access to those lab machines could be 
privately share with the maintener and a live demo of the issue can be 
organised).

I would be happy if I could help, let me know how to

Thanks for help
Kind regards
Nicolas Baranger


