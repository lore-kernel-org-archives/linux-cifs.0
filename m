Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6998129A1
	for <linux-cifs@vger.kernel.org>; Thu, 11 Sep 2025 04:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757565145; cv=none; b=lgZPRpKh+QSNv1MgSs3q6eacHu/ec+WU1LCFZLROT+epHAPTGbg7KqnOf/j+GcdkQgskjI9efrD4seV6j1bnshxDd4XWBN32d9PdgTDACXkLQE/DctlG78KggM4Ke9snZxKp9RskXcdtRUyouGsb8gAskC1ng2M5VVy41C+LRrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757565145; c=relaxed/simple;
	bh=TPuzvBPZQMZQLkglXaXnpu8vSg3Wv97kAbD7uswbawI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Oe518JjYSSIBYtkON4pI93nxwBGhsc4hzzVhTYOKArH1AOLFIF5AsKddJqkBkNNTKJ4v2vV06C7me1XYIIRgHEqnjhK13fNK+eFMJqCVpNEab5n/AEXGt11IqGeJ6AOefHgK+4ItQVInRZW4zGQNXe9VkomYzm1G41zdPjyAz40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maniscalco.com; spf=none smtp.mailfrom=maniscalco.com; dkim=pass (2048-bit key) header.d=maniscalco-com.20230601.gappssmtp.com header.i=@maniscalco-com.20230601.gappssmtp.com header.b=FQ2oHgSo; arc=none smtp.client-ip=209.85.167.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=maniscalco.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=maniscalco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=maniscalco-com.20230601.gappssmtp.com header.i=@maniscalco-com.20230601.gappssmtp.com header.b="FQ2oHgSo"
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-560880bb751so238428e87.3
        for <linux-cifs@vger.kernel.org>; Wed, 10 Sep 2025 21:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=maniscalco-com.20230601.gappssmtp.com; s=20230601; t=1757565138; x=1758169938; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ekAz+DRI2soxTl7GYazefeW4wolijosuld+XF99i19U=;
        b=FQ2oHgSocH0h8U8jz7qZYBhi2vu7lCtYNssevAfX8oI46p1vfhDglV40wLU7U1LRZ3
         wc9wYpJwArROK5a6i0p8oEXw9mmp4FU6vfUvSnS3SVkNTQ6RPdiUQiQ+yLk+kp4camux
         y1Vizi78D2p4nR9nR5xZjBCNeVFMtAxoBigmeLAnT8XRRWsFH1cAisdEqJ1ZfrsRU34I
         8oKLpdoIy5FYFssMkL8id2B+aZDTF3u7Rzqc0z5UdlgZoUko2xWtkuKEoOcN4MOXAcwG
         1lihbW+2siyhkWS6xFAXNyBVndBrB1SIUmTIh0JBtRuNkMrMGhdHTRkRKU8alL+iUhY6
         xE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757565138; x=1758169938;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ekAz+DRI2soxTl7GYazefeW4wolijosuld+XF99i19U=;
        b=O7mIrr5YAIJ92wwRlV82qgQpnLERwwGpQampPrjck/Dv2xWZbeG2EAguHnmuYi7hsA
         m6XTq6ayqrPdidBhclkWjUdRbsMXfMV2zUco8M8s+H2nORd9C45VJCeequlXNV7JSwzJ
         y3o15diexmSbbgmJ3Z3/sXveBc6FHZJTAa5FlZ1SPkhWwgOgpPtFGEWf/DBivWhdswmw
         ndwef9xED6U2ZY8Ix/x1fmZN9ICG4TZK2ilt0WdNLEYwHe9O642YlCmowiIZ0OlFEir7
         vCIEiF01nQ4hgVtMf1X97qrnYg+gTPRJsF6nFOueMRHuDVTukuZRYZ4KMVVw36ytKJXE
         n2Zw==
X-Gm-Message-State: AOJu0Yzljv5IslVv+F8kY4qrQzRbz3LFVZByku+Yic/FAX83d6m4j9JP
	hgu3tHLoSaD/mKUfpIJgtuCtJxznbC3Pnzo36KpJ3NrBHG4CeCvMke2CU/VOJ/V1IzrWa2z16TT
	y5CR0cOqNVcgQn5XrjnIvpGfsSPY7Z4LI6Q+nYQrF8gwjnrfyirkvWPU=
X-Gm-Gg: ASbGncvrwZeJpaSWvXXyuGyiwwVaGHFPG/pxHu8NoD72oyNFJE8ONobwKgbRSaFL/iH
	fkKy6wFKsJWYb1ZOZ5bAfyiM1UAJvdOaHIMRX6b4fL/V4W9liEGNsah5kPkKHe/Txul4bQFvGuy
	o90dyVFbS8KGgFSE/T/HK4uyEczodwlYplexpbJGajODCNr82hGQ6WLdfuJE+DoHjfGrxr/YCqB
	ZeuRMtz5dGHjYciz3M09GhBpsJapov/s8AL7RzXpn8rpZdZDgM=
X-Google-Smtp-Source: AGHT+IGzfPAD0K6+qKI1LspYsCUtFbshOJkF49nsdoZzzw6n6UzhoSj/sf7k/iMnCubEFq4qo1wfX06AMvG5xSDn778=
X-Received: by 2002:a05:6512:2c94:b0:55f:4953:ae88 with SMTP id
 2adb3069b0e04-562603a2874mr5688235e87.11.1757565136711; Wed, 10 Sep 2025
 21:32:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nicholas Maniscalco <nicholas@maniscalco.com>
Date: Wed, 10 Sep 2025 21:32:05 -0700
X-Gm-Features: Ac12FXxfH8u4NeuTvk3euZ_MblRNte9moetqZcUwr-vcVsHddby9FEWyLQ_0zTY
Message-ID: <CAAK4eBEEAxGf9KdUTnWPQVB1fjXXky_4QAv4ZbDRtdQt3sDASw@mail.gmail.com>
Subject: multichannel with global encryption fails to open extra channel
To: linux-cifs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Greetings!

I'm seeing some behavior that I don't understand.  My cifs client
cannot establish a multichannel session when the Samba server is
configured with global encryption required.

In at least one case, the client receives a STATUS_ACCESS_DENIED and
reports "failed to open extra channel on...".

By "global encryption required" I mean specifying "server smb encrypt
= required" in the "[global]" section as opposed to specifying it in a
share section.

Updating the Samba server to require encryption on a particular share
(rather than in the global section) seems to resolve the issue.  That
is, multichannel then works as I would expect.

I have tested four cases and have included diagnostic data for each.

In all four cases,

- client is Linux 6.17.0-rc5 with mount.cifs version: 7.4
- client has one NIC
- client has IP address 192.168.1.82

- server is Samba 4.22.4-Debian-4.22.4+dfsg-1~deb13u1
- server has one NIC
- server has two IP addresses on the one NIC, 192.168.1.80 and 192.168.1.81

Case 1 -
client mounts with multichannel
server has global encryption required
Result: failure to establish second channel

Case 2 -
client mounts with multichannel+seal
server has global encryption required
Result: failure to establish second channel

Case 3 -
client mounts with multichannel
server has share encryption required
Result: success in establishing second channel

Case 4 -
client mounts with multichannel+seal
server has share encryption required
Result: success in establishing second channel

I've included the script I'm using to test the four cases along with
the dmesg output and DebugData for each case at the end of this email.

Is this behavior expected?  Have I misconfigured anything?  I would be
happy to run experiments, gather more data, or file a bug report.
Just ask!

Thanks for reading!

--

root@client:~# cat repro.sh
#!/bin/bash

set -o xtrace

SERVER_IP=192.168.1.80 # and 192.168.1.81
SHARE=\\\\$SERVER_IP\\files

function run_test() {
    CASE=$1
    OPTS=$2
    echo
    echo BEGIN ${CASE}
    ssh ${SERVER_IP} cp /etc/samba/smb.conf-${CASE} /etc/samba/smb.conf
    ssh ${SERVER_IP} systemctl restart smbd
    dmesg -c > /dev/null
    sleep 1
    mount.cifs -o ${OPTS} ${SHARE} /mnt
    sleep 1
    dmesg > ${CASE}-dmesg.txt
    cat /proc/fs/cifs/DebugData > ${CASE}-debugdata.txt
    umount /mnt
    cat ${CASE}-dmesg.txt
    cat ${CASE}-debugdata.txt
    ssh ${SERVER_IP} cat /etc/samba/smb.conf
    echo END ${CASE}
    echo
}

COMMON_OPTS=multichannel,vers=3.1.1,user=user,password=user

echo "Case 1, client multichannel, server has global encryption required"
run_test "case1" "${COMMON_OPTS}"

echo "Case 2, client multichannel+seal, server has global encryption required"
run_test "case2" "seal,${COMMON_OPTS}"

echo "Case 3, client multichannel, server has global encryption required"
run_test "case3" "${COMMON_OPTS}"

echo "Case 4, client multichannel+seal, server has share-specific
encryption required"
run_test "case4" "seal,${COMMON_OPTS}"
root@client:~# ./repro.sh
+ SERVER_IP=192.168.1.80
+ SHARE='\\192.168.1.80\files'
+ COMMON_OPTS=multichannel,vers=3.1.1,user=user,password=user
+ echo 'Case 1, client multichannel, server has global encryption required'
Case 1, client multichannel, server has global encryption required
+ run_test case1 multichannel,vers=3.1.1,user=user,password=user
+ CASE=case1
+ OPTS=multichannel,vers=3.1.1,user=user,password=user
+ echo

+ echo BEGIN case1
BEGIN case1
+ ssh 192.168.1.80 cp /etc/samba/smb.conf-case1 /etc/samba/smb.conf
+ ssh 192.168.1.80 systemctl restart smbd
+ dmesg -c
+ sleep 1
+ mount.cifs -o multichannel,vers=3.1.1,user=user,password=user
'\\192.168.1.80\files' /mnt
+ sleep 1
+ dmesg
+ cat /proc/fs/cifs/DebugData
+ umount /mnt
+ cat case1-dmesg.txt
[178705.275471] smb3_fs_context_parse_param: 5 callbacks suppressed
[178705.275476] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'source'
[178705.275484] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'ip'
[178705.275487] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'unc'
[178705.275489] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'multichannel'
[178705.275491] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'vers'
[178705.275494] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'user'
[178705.275495] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'pass'
[178705.275499] CIFS: fs/smb/client/cifsfs.c: cifs_smb3_do_mount:
devname=//192.168.1.80/files flags=0x0
[178705.275502] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 0755
[178705.275506] CIFS: fs/smb/client/connect.c: VFS: in
cifs_mount_get_session as Xid: 1259 with uid: 0
[178705.275508] CIFS: fs/smb/client/connect.c: UNC: \\192.168.1.80\files
[178705.275511] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178705.275521] CIFS: fs/smb/client/connect.c: Socket created
[178705.275522] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.276008] CIFS: fs/smb/client/connect.c: VFS: in
cifs_get_smb_ses as Xid: 1260 with uid: 0
[178705.276013] CIFS: fs/smb/client/connect.c: Existing smb sess not found
[178705.276016] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7030
[178705.276018] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.276026] wait_for_free_credits: 40 callbacks suppressed
[178705.276027] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178705.276039] __smb_send_rqst: 40 callbacks suppressed
[178705.276040] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=228
[178705.280215] cifs_demultiplex_thread: 40 callbacks suppressed
[178705.280218] CIFS: fs/smb/client/connect.c: RFC1002 header 0x10c
[178705.280226] smb2_calc_size: 30 callbacks suppressed
[178705.280227] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 74 offset 128
[178705.280230] smb2_calc_size: 46 callbacks suppressed
[178705.280231] CIFS: fs/smb/client/smb2misc.c: SMB2 len 202
[178705.280233] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.280237] smb2_add_credits: 46 callbacks suppressed
[178705.280239] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
1 credits total=1
[178705.280263] cifs_sync_mid_result: 46 callbacks suppressed
[178705.280265] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=0 mid=0 state=64
[178705.280270] cifs_small_buf_release: 30 callbacks suppressed
[178705.280271] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.280274] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.280277] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.280284] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.280287] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.280289] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.280298] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x1
[178705.280303] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.280306] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.280307] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.280309] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178705.280312] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178705.280316] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=136
[178705.280661] CIFS: fs/smb/client/connect.c: RFC1002 header 0xf6
[178705.280667] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 174 offset 72
[178705.280670] CIFS: fs/smb/client/smb2misc.c: SMB2 len 246
[178705.280672] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
1 credits total=1
[178705.280687] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=1 mid=1 state=64
[178705.280700] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178705.280705] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000016 to POSIX err -5
[178705.280711] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.280714] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178705.280716] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178705.280719] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178705.280734] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178705.280738] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=388
[178705.290956] CIFS: fs/smb/client/connect.c: RFC1002 header 0x48
[178705.290964] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 0 offset 72
[178705.290967] CIFS: fs/smb/client/smb2misc.c: SMB2 len 73
[178705.290969] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
130 credits total=130
[178705.290998] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=1 mid=2 state=64
[178705.291004] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.291015] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178705.291019] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 0; now 0x0
[178705.291023] CIFS: fs/smb/client/connect.c: VFS: in cifs_setup_ipc
as Xid: 1261 with uid: 0
[178705.291025] CIFS: fs/smb/client/smb2pdu.c: TCON
[178705.291028] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=129
[178705.291038] smb3_init_transform_rq: 23 callbacks suppressed
[178705.291039] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.291046] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=166
[178705.291406] CIFS: fs/smb/client/connect.c: RFC1002 header 0x84
[178705.291415] decrypt_raw_data: 23 callbacks suppressed
[178705.291417] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.291419] receive_encrypted_standard: 29 callbacks suppressed
[178705.291420] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.291422] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178705.291424] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
64 credits total=191
[178705.291439] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=3 mid=3 state=64
[178705.291442] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.291444] CIFS: fs/smb/client/smb2pdu.c: connection to pipe share
[178705.291446] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_setup_ipc (xid = 1261) rc = 0
[178705.291448] CIFS: fs/smb/client/connect.c: IPC tcon rc=0 ipc tid=0xfad2681e
[178705.291450] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_smb_ses (xid = 1260) rc = 0
[178705.291454] CIFS: fs/smb/client/dfs_cache.c: cache_refresh_path:
search path: \192.168.1.80\files
[178705.291458] CIFS: fs/smb/client/dfs_cache.c: get_dfs_referral:
ipc=\\192.168.1.80\IPC$ referral=\192.168.1.80\files
[178705.291460] CIFS: fs/smb/client/smb2ops.c: smb2_get_dfs_refer:
path: \192.168.1.80\files
[178705.291463] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178705.291467] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=190
[178705.291470] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.291473] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=218
[178705.291715] CIFS: fs/smb/client/connect.c: RFC1002 header 0x7d
[178705.291724] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.291726] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.291728] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 0 offset 0
[178705.291730] CIFS: fs/smb/client/smb2misc.c: SMB2 len 73
[178705.291732] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=200
[178705.291742] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=11 mid=4 state=64
[178705.291745] CIFS: Status code returned 0xc0000225 STATUS_NOT_FOUND
[178705.291747] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000225 to POSIX err -2
[178705.291749] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.291750] CIFS: fs/smb/client/dfs.c: dfs_mount_share: no dfs
referral for \192.168.1.80\files: -2
[178705.291752] CIFS: fs/smb/client/dfs.c: dfs_mount_share: assuming
non-dfs mount...
[178705.291755] CIFS: fs/smb/client/connect.c: VFS: in cifs_get_tcon
as Xid: 1262 with uid: 0
[178705.291756] CIFS: fs/smb/client/smb2pdu.c: TCON
[178705.291757] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=199
[178705.291763] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.291768] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=168
[178705.292080] CIFS: fs/smb/client/connect.c: RFC1002 header 0x84
[178705.292089] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.292091] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.292093] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178705.292095] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
64 credits total=263
[178705.292106] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=3 mid=5 state=64
[178705.292107] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.292109] CIFS: fs/smb/client/smb2pdu.c: connection to disk share
[178705.292110] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_tcon (xid = 1262) rc = 0
[178705.292111] CIFS: fs/smb/client/connect.c: Tcon rc = 0
[178705.292114] CIFS: fs/smb/client/smb2pdu.c: create/open
[178705.292116] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=262
[178705.292120] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.292124] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=208
[178705.292471] CIFS: fs/smb/client/connect.c: RFC1002 header 0x104
[178705.292479] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.292481] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.292483] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 56 offset 152
[178705.292485] CIFS: fs/smb/client/smb2misc.c: SMB2 len 208
[178705.292487] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=272
[178705.292497] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=5 mid=6 state=64
[178705.292499] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.292501] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178705.292502] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=271
[178705.292505] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.292507] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=177
[178705.292796] CIFS: fs/smb/client/connect.c: RFC1002 header 0x1d4
[178705.292802] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.292804] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.292805] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 304 offset 112
[178705.292807] CIFS: fs/smb/client/smb2misc.c: SMB2 len 416
[178705.292808] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=281
[178705.292817] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=11 mid=7 state=64
[178705.292820] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.81
[178705.292822] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 0
[178705.292823] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178705.292824] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178705.292826] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.80
[178705.292827] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 1
[178705.292828] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178705.292829] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178705.292831] CIFS: fs/smb/client/sess.c: referencing primary
channel iface: 192.168.1.80
[178705.292834] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 5
[178705.292836] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=280
[178705.292838] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.292841] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=161
[178705.292971] CIFS: fs/smb/client/connect.c: RFC1002 header 0x90
[178705.292977] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.292978] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.292980] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 20 offset 72
[178705.292981] CIFS: fs/smb/client/smb2misc.c: SMB2 len 92
[178705.292982] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=290
[178705.294066] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=16 mid=8 state=64
[178705.294068] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.294070] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 4
[178705.294072] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=289
[178705.294075] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.294078] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=161
[178705.294185] CIFS: fs/smb/client/connect.c: RFC1002 header 0x84
[178705.294193] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.294195] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.294197] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 8 offset 72
[178705.294199] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178705.294201] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=299
[178705.294213] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=16 mid=9 state=64
[178705.294215] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.294216] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 1
[178705.294219] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.294328] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.294332] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.294334] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 28 offset 72
[178705.294345] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178705.294346] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 11
[178705.294349] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.294420] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.294422] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.294424] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 28 offset 72
[178705.294434] CIFS: fs/smb/client/smb2pdu.c: Close
[178705.294437] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178705.294515] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178705.294517] CIFS: fs/smb/client/smb2ops.c: mid found
[178705.294526] CIFS: fs/smb/client/connect.c: cifs_is_path_remote: full_path:
[178705.294528] CIFS: fs/smb/client/smb2pdu.c: create/open
[178705.294636] CIFS: fs/smb/client/smb2pdu.c: Close
[178705.294739] CIFS: fs/smb/client/smb2pdu.c: create/open
[178705.294903] CIFS: fs/smb/client/smb2pdu.c: Close
[178705.294997] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1263 with uid: 0
[178705.294999] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.295002] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.295004] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178705.295011] CIFS: fs/smb/client/connect.c: Socket created
[178705.295012] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.295184] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.295187] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7031
[178705.295195] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.297692] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.297720] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.297724] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.297728] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.297730] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.297732] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.297737] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.297739] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.297742] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.297743] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.297745] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.297890] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.297895] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.297899] cifs_setup_session: 12 callbacks suppressed
[178705.297900] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.298099] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.298102] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1263) rc = -13
[178705.298104] cifs_try_adding_channels: 12 callbacks suppressed
[178705.298105] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.298259] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1264 with uid: 0
[178705.298262] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.298266] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.298268] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178705.298276] CIFS: fs/smb/client/connect.c: Socket created
[178705.298278] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.298427] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.298432] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7032
[178705.298434] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.300679] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.300708] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.300711] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.300713] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.300714] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.300716] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.300719] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.300720] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.300722] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.300723] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.300725] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.300817] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.300820] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.300822] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.300947] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.300966] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1264) rc = -13
[178705.300968] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.301083] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1265 with uid: 0
[178705.301085] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.80)
[178705.301088] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.301091] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178705.301099] CIFS: fs/smb/client/connect.c: Socket created
[178705.301100] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.301225] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.301234] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.301270] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7033
[178705.303384] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.303400] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.303403] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.303405] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.303406] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.303407] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.303411] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.303412] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.303414] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.303415] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.303416] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.303514] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.303517] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.303520] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.303696] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.303698] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1265) rc = -13
[178705.303701] CIFS: VFS: failed to open extra channel on
iface:192.168.1.80 rc=-13
[178705.303850] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1266 with uid: 0
[178705.303852] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.303856] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.303858] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178705.303865] CIFS: fs/smb/client/connect.c: Socket created
[178705.303867] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.304001] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.304007] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7034
[178705.304007] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.306089] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.306121] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.306124] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.306127] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.306128] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.306130] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.306134] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.306136] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.306138] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.306139] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.306141] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.306233] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.306236] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.306239] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.306404] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.306406] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1266) rc = -13
[178705.306408] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.306546] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1267 with uid: 0
[178705.306548] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.80)
[178705.306551] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.306554] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178705.306561] CIFS: fs/smb/client/connect.c: Socket created
[178705.306562] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.306692] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7035
[178705.306688] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.306700] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.308620] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.308645] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.308647] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.308650] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.308651] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.308652] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.308655] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.308656] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.308658] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.308659] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.308660] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.308764] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.308767] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.308770] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.308885] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.308887] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1267) rc = -13
[178705.308888] CIFS: VFS: failed to open extra channel on
iface:192.168.1.80 rc=-13
[178705.308998] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1268 with uid: 0
[178705.309000] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.309002] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.309005] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178705.309010] CIFS: fs/smb/client/connect.c: Socket created
[178705.309011] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.309114] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.309119] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.309139] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7036
[178705.311091] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.311104] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.311105] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.311108] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.311109] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.311111] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.311115] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.311117] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.311119] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.311120] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.311122] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.311215] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.311218] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.311221] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.311375] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.311377] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1268) rc = -13
[178705.311379] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.311516] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1269 with uid: 0
[178705.311518] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.80)
[178705.311526] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.311529] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178705.311536] CIFS: fs/smb/client/connect.c: Socket created
[178705.311538] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.311655] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.311659] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7037
[178705.311661] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.313942] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.313969] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.313971] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.313973] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.313974] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.313975] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.313979] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.313980] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.313981] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.313982] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.313983] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.314074] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.314077] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.314079] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.314199] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.314201] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1269) rc = -13
[178705.314202] CIFS: VFS: failed to open extra channel on
iface:192.168.1.80 rc=-13
[178705.314334] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1270 with uid: 0
[178705.314336] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.314339] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.314342] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178705.314349] CIFS: fs/smb/client/connect.c: Socket created
[178705.314351] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.314482] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.314486] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7038
[178705.314491] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.316512] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.316538] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.316540] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.316543] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.316544] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.316545] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.316548] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.316550] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.316551] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.316552] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.316553] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.316640] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.316643] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000022 to POSIX err -13
[178705.316645] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.316774] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.316775] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1270) rc = -13
[178705.316777] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.316876] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1271 with uid: 0
[178705.316878] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.80)
[178705.316880] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178705.316882] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178705.316887] CIFS: fs/smb/client/connect.c: Socket created
[178705.316888] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178705.317006] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.317012] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178705.317032] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7039
[178705.319024] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178705.319037] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178705.319038] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178705.319041] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178705.319042] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178705.319044] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178705.319048] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178705.319050] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178705.319052] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178705.319053] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178705.319055] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.319147] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.319152] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.319313] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178705.319315] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1271) rc = -13
[178705.319317] CIFS: VFS: failed to open extra channel on
iface:192.168.1.80 rc=-13
[178705.319454] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1272 with uid: 0
[178705.319456] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000f9bb5854 (speed:10000 bps rdma:no ip:192.168.1.81)
[178705.319588] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178705.321537] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 43abb460
[178705.321632] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.321635] CIFS: VFS: \\192.168.1.80 Send error in SessSetup = -13
[178705.321768] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1272) rc = -13
[178705.321770] CIFS: VFS: failed to open extra channel on
iface:192.168.1.81 rc=-13
[178705.324106] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178705.324117] CIFS: VFS: too many channel open attempts (1 channels
left to open)
[178705.324274] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount
(xid = 1259) rc = 0
[178705.324347] CIFS: fs/smb/client/inode.c: VFS: in cifs_root_iget as
Xid: 1274 with uid: 0
[178705.324611] CIFS: fs/smb/client/inode.c: looking for uniqueid=1310721
[178705.324620] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
revalidating inode 1310721
[178705.324622] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
inode 1310721 is new
[178705.324624] CIFS: fs/smb/client/inode.c: VFS: leaving
cifs_root_iget (xid = 1274) rc = 0
[178705.324628] CIFS: fs/smb/client/cifsfs.c: Get root dentry for
[178705.324630] CIFS: fs/smb/client/cifsfs.c: dentry root is: 00000000ebb51f32
+ cat case1-debugdata.txt
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.56
Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x246 Hostname: 192.168.1.80
ClientGUID: 452039EB-B195-9747-BF07-6AB9AF7E7D3C
Number of credits: 389,1,1 Dialect 0x311 signed
Server capabilities: 0x30006f
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0 Net namespace: 4026531833
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support
Encryption: Negotiated cipher (AES128-GCM)

    Sessions:
    1) Address: 192.168.1.80 Uses: 1 Capability: 0x30006f    Session
Status: 1 password no longer valid
    Security type: RawNTLMSSP  SessionId: 0x43abb460 encrypted
    User: 0 Cred User: 0

    Shares:
    0) IPC: \\192.168.1.80\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
    PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 encrypted
    Share Capabilities: None    Share Flags: 0x8000
    tid: 0xfad2681e    Maximal Access: 0x1f00a9

    1) \\192.168.1.80\files Mounts: 1 DevInfo: 0x22 Attributes: 0x1006f
    PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0xe1c466ed encrypted
    Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x8000
    tid: 0xf26ce732    Optimal sector size: 0x200    Maximal Access: 0x1f00a9


    Server interfaces: 2    Last updated: 1 seconds ago
    1)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.81
        Weight (cur,total): (0,1)
        Allocated channels: 0

    2)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.80
        Weight (cur,total): (0,1)
        Allocated channels: 1
        [CONNECTED]


    MIDs:
--

+ ssh 192.168.1.80 cat /etc/samba/smb.conf
[global]
interfaces = "192.168.1.80;capability=RSS,speed=10000"
"192.168.1.81;capability=RSS,speed=10000"
workgroup = WORKGROUP
server role = standalone server
passdb backend = tdbsam
obey pam restrictions = yes
server signing = mandatory
server min protocol = SMB3_11
server multi channel support = yes

server smb encrypt = required

[files]
path = /files
public = no
writable = no
printable = no
+ echo END case1
END case1
+ echo

+ echo 'Case 2, client multichannel+seal, server has global encryption required'
Case 2, client multichannel+seal, server has global encryption required
+ run_test case2 seal,multichannel,vers=3.1.1,user=user,password=user
+ CASE=case2
+ OPTS=seal,multichannel,vers=3.1.1,user=user,password=user
+ echo

+ echo BEGIN case2
BEGIN case2
+ ssh 192.168.1.80 cp /etc/samba/smb.conf-case2 /etc/samba/smb.conf
+ ssh 192.168.1.80 systemctl restart smbd
+ dmesg -c
+ sleep 1
+ mount.cifs -o seal,multichannel,vers=3.1.1,user=user,password=user
'\\192.168.1.80\files' /mnt
+ sleep 1
+ dmesg
+ cat /proc/fs/cifs/DebugData
+ umount /mnt
+ cat case2-dmesg.txt
[178707.961298] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'source'
[178707.961309] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'ip'
[178707.961313] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'unc'
[178707.961321] CIFS: fs/smb/client/cifsfs.c: cifs_smb3_do_mount:
devname=//192.168.1.80/files flags=0x0
[178707.961325] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 0755
[178707.961329] CIFS: fs/smb/client/connect.c: VFS: in
cifs_mount_get_session as Xid: 1278 with uid: 0
[178707.961841] CIFS: fs/smb/client/connect.c: VFS: in
cifs_get_smb_ses as Xid: 1279 with uid: 0
[178707.961846] CIFS: fs/smb/client/connect.c: Existing smb sess not found
[178707.966202] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178707.966582] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178707.966589] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178707.966593] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178707.966595] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178707.976696] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178707.976704] CIFS: fs/smb/client/connect.c: VFS: in cifs_setup_ipc
as Xid: 1280 with uid: 0
[178707.976707] CIFS: fs/smb/client/smb2pdu.c: TCON
[178707.977085] CIFS: fs/smb/client/smb2pdu.c: connection to pipe share
[178707.977089] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_setup_ipc (xid = 1280) rc = 0
[178707.977091] CIFS: fs/smb/client/connect.c: IPC tcon rc=0 ipc tid=0xfee53fb9
[178707.977093] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_smb_ses (xid = 1279) rc = 0
[178707.977096] CIFS: fs/smb/client/dfs_cache.c: cache_refresh_path:
search path: \192.168.1.80\files
[178707.977100] CIFS: fs/smb/client/dfs_cache.c: get_dfs_referral:
ipc=\\192.168.1.80\IPC$ referral=\192.168.1.80\files
[178707.977102] CIFS: fs/smb/client/smb2ops.c: smb2_get_dfs_refer:
path: \192.168.1.80\files
[178707.977105] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178707.977338] CIFS: Status code returned 0xc0000225 STATUS_NOT_FOUND
[178707.977342] CIFS: fs/smb/client/dfs.c: dfs_mount_share: no dfs
referral for \192.168.1.80\files: -2
[178707.977344] CIFS: fs/smb/client/dfs.c: dfs_mount_share: assuming
non-dfs mount...
[178707.977347] CIFS: fs/smb/client/connect.c: VFS: in cifs_get_tcon
as Xid: 1281 with uid: 0
[178707.977348] CIFS: fs/smb/client/smb2pdu.c: TCON
[178707.977646] CIFS: fs/smb/client/smb2pdu.c: connection to disk share
[178707.977647] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_tcon (xid = 1281) rc = 0
[178707.977649] CIFS: fs/smb/client/connect.c: Tcon rc = 0
[178707.977651] CIFS: fs/smb/client/smb2pdu.c: create/open
[178707.977969] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178707.978192] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.81
[178707.978194] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 0
[178707.978196] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178707.978197] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178707.978198] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.80
[178707.978200] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 1
[178707.978201] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178707.978202] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178707.978204] CIFS: fs/smb/client/sess.c: referencing primary
channel iface: 192.168.1.80
[178707.978206] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 5
[178707.978309] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 4
[178707.978387] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 1
[178707.978450] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 11
[178707.978514] CIFS: fs/smb/client/smb2pdu.c: Close
[178707.978585] CIFS: fs/smb/client/connect.c: cifs_is_path_remote: full_path:
[178707.978586] CIFS: fs/smb/client/smb2pdu.c: create/open
[178707.978679] CIFS: fs/smb/client/smb2pdu.c: Close
[178707.978748] CIFS: fs/smb/client/smb2pdu.c: create/open
[178707.978840] CIFS: fs/smb/client/smb2pdu.c: Close
[178707.981207] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.983665] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.985772] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.987841] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.989887] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.991930] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.994004] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.996040] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178707.998104] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178708.000145] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178708.002182] CIFS: Status code returned 0xc0000022 STATUS_ACCESS_DENIED
[178708.002192] CIFS: VFS: too many channel open attempts (1 channels
left to open)
[178708.002388] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount
(xid = 1278) rc = 0
[178708.002460] CIFS: fs/smb/client/inode.c: VFS: in cifs_root_iget as
Xid: 1293 with uid: 0
[178708.002894] CIFS: fs/smb/client/inode.c: looking for uniqueid=1310721
[178708.002903] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
revalidating inode 1310721
[178708.002906] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
inode 1310721 is new
[178708.002909] CIFS: fs/smb/client/inode.c: VFS: leaving
cifs_root_iget (xid = 1293) rc = 0
[178708.002913] CIFS: fs/smb/client/cifsfs.c: Get root dentry for
[178708.002916] CIFS: fs/smb/client/cifsfs.c: dentry root is: 000000004b927ac7
+ cat case2-debugdata.txt
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.56
Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x252 Hostname: 192.168.1.80
ClientGUID: 48B4CE3C-2ADA-EF46-9D5D-A61C5BE7551A
Number of credits: 389,1,1 Dialect 0x311 signed
Server capabilities: 0x30006f
TCP status: 1 Instance: 1
Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0 Net namespace: 4026531833
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support
Encryption: Negotiated cipher (AES128-GCM)

    Sessions:
    1) Address: 192.168.1.80 Uses: 1 Capability: 0x30006f    Session
Status: 1 password no longer valid
    Security type: RawNTLMSSP  SessionId: 0x4bf5dbd2 encrypted
    User: 0 Cred User: 0

    Shares:
    0) IPC: \\192.168.1.80\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
    PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 encrypted
    Share Capabilities: None    Share Flags: 0x8000
    tid: 0xfee53fb9    Maximal Access: 0x1f00a9

    1) \\192.168.1.80\files Mounts: 1 DevInfo: 0x22 Attributes: 0x1006f
    PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0xe1c466ed encrypted
    Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x8000
    tid: 0x2f05f04a    Optimal sector size: 0x200    Maximal Access: 0x1f00a9


    Server interfaces: 2    Last updated: 1 seconds ago
    1)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.81
        Weight (cur,total): (0,1)
        Allocated channels: 0

    2)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.80
        Weight (cur,total): (0,1)
        Allocated channels: 1
        [CONNECTED]


    MIDs:
--

+ ssh 192.168.1.80 cat /etc/samba/smb.conf
[global]
interfaces = "192.168.1.80;capability=RSS,speed=10000"
"192.168.1.81;capability=RSS,speed=10000"
workgroup = WORKGROUP
server role = standalone server
passdb backend = tdbsam
obey pam restrictions = yes
server signing = mandatory
server min protocol = SMB3_11
server multi channel support = yes

server smb encrypt = required

[files]
path = /files
public = no
writable = no
printable = no
+ echo END case2
END case2
+ echo

+ echo 'Case 3, client multichannel, server has global encryption required'
Case 3, client multichannel, server has global encryption required
+ run_test case3 multichannel,vers=3.1.1,user=user,password=user
+ CASE=case3
+ OPTS=multichannel,vers=3.1.1,user=user,password=user
+ echo

+ echo BEGIN case3
BEGIN case3
+ ssh 192.168.1.80 cp /etc/samba/smb.conf-case3 /etc/samba/smb.conf
+ ssh 192.168.1.80 systemctl restart smbd
+ dmesg -c
+ sleep 1
+ mount.cifs -o multichannel,vers=3.1.1,user=user,password=user
'\\192.168.1.80\files' /mnt
+ sleep 1
+ dmesg
+ cat /proc/fs/cifs/DebugData
+ umount /mnt
+ cat case3-dmesg.txt
[178710.637387] smb3_fs_context_parse_param: 5 callbacks suppressed
[178710.637391] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'source'
[178710.637399] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'ip'
[178710.637402] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'unc'
[178710.637404] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'multichannel'
[178710.637405] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'vers'
[178710.637408] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'user'
[178710.637410] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'pass'
[178710.637413] CIFS: fs/smb/client/cifsfs.c: cifs_smb3_do_mount:
devname=//192.168.1.80/files flags=0x0
[178710.637417] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 0755
[178710.637421] CIFS: fs/smb/client/connect.c: VFS: in
cifs_mount_get_session as Xid: 1297 with uid: 0
[178710.637423] cifs_get_tcp_session: 14 callbacks suppressed
[178710.637423] CIFS: fs/smb/client/connect.c: UNC: \\192.168.1.80\files
[178710.637427] generic_ip_connect: 14 callbacks suppressed
[178710.637428] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178710.637436] generic_ip_connect: 14 callbacks suppressed
[178710.637437] CIFS: fs/smb/client/connect.c: Socket created
[178710.637438] generic_ip_connect: 14 callbacks suppressed
[178710.637439] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178710.637862] CIFS: fs/smb/client/connect.c: VFS: in
cifs_get_smb_ses as Xid: 1298 with uid: 0
[178710.637866] CIFS: fs/smb/client/connect.c: Existing smb sess not found
[178710.637866] cifs_demultiplex_thread: 14 callbacks suppressed
[178710.637868] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7081
[178710.637872] SMB2_negotiate: 14 callbacks suppressed
[178710.637873] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178710.637879] wait_for_free_credits: 78 callbacks suppressed
[178710.637881] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178710.637894] __smb_send_rqst: 78 callbacks suppressed
[178710.637895] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=228
[178710.642341] cifs_demultiplex_thread: 78 callbacks suppressed
[178710.642351] CIFS: fs/smb/client/connect.c: RFC1002 header 0x10c
[178710.642358] smb2_calc_size: 68 callbacks suppressed
[178710.642360] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 74 offset 128
[178710.642362] smb2_calc_size: 84 callbacks suppressed
[178710.642363] CIFS: fs/smb/client/smb2misc.c: SMB2 len 202
[178710.642365] get_neg_ctxt_len: 14 callbacks suppressed
[178710.642366] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178710.642370] smb2_add_credits: 84 callbacks suppressed
[178710.642371] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
1 credits total=1
[178710.642414] cifs_sync_mid_result: 84 callbacks suppressed
[178710.642417] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=0 mid=0 state=64
[178710.642424] cifs_small_buf_release: 68 callbacks suppressed
[178710.642425] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.642428] SMB2_negotiate: 14 callbacks suppressed
[178710.642430] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178710.642433] SMB2_negotiate: 14 callbacks suppressed
[178710.642435] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178710.642439] smb311_decode_neg_context: 14 callbacks suppressed
[178710.642440] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178710.642441] decode_encrypt_ctx: 14 callbacks suppressed
[178710.642442] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178710.642443] decode_encrypt_ctx: 14 callbacks suppressed
[178710.642443] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178710.642448] cifs_setup_session: 14 callbacks suppressed
[178710.642449] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x1
[178710.642451] cifs_setup_session: 14 callbacks suppressed
[178710.642452] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178710.642453] SMB2_sess_setup: 14 callbacks suppressed
[178710.642454] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178710.642455] SMB2_select_sec: 14 callbacks suppressed
[178710.642456] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178710.642458] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178710.642460] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178710.642465] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=136
[178710.642696] CIFS: fs/smb/client/connect.c: RFC1002 header 0xf6
[178710.642699] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 174 offset 72
[178710.642700] CIFS: fs/smb/client/smb2misc.c: SMB2 len 246
[178710.642702] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
1 credits total=1
[178710.642711] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=1 mid=1 state=64
[178710.642713] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178710.642715] map_smb2_to_linux_error: 16 callbacks suppressed
[178710.642716] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000016 to POSIX err -5
[178710.642719] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.642720] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178710.642723] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178710.642724] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178710.642736] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=0
[178710.642739] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=388
[178710.652739] CIFS: fs/smb/client/connect.c: RFC1002 header 0x48
[178710.652747] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 0 offset 72
[178710.652750] CIFS: fs/smb/client/smb2misc.c: SMB2 len 73
[178710.652753] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
130 credits total=130
[178710.652768] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=1 mid=2 state=64
[178710.652773] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.652780] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178710.652783] cifs_chan_clear_need_reconnect: 16 callbacks suppressed
[178710.652784] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 0; now 0x0
[178710.652788] CIFS: fs/smb/client/connect.c: VFS: in cifs_setup_ipc
as Xid: 1299 with uid: 0
[178710.652790] CIFS: fs/smb/client/smb2pdu.c: TCON
[178710.652793] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=129
[178710.652803] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=114
[178710.653048] CIFS: fs/smb/client/connect.c: RFC1002 header 0x50
[178710.653051] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178710.653053] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
64 credits total=191
[178710.653065] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=3 mid=3 state=64
[178710.653073] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.653076] CIFS: fs/smb/client/smb2pdu.c: connection to pipe share
[178710.653078] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_setup_ipc (xid = 1299) rc = 0
[178710.653079] CIFS: fs/smb/client/connect.c: IPC tcon rc=0 ipc tid=0x55490b4c
[178710.653082] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_smb_ses (xid = 1298) rc = 0
[178710.653084] CIFS: fs/smb/client/dfs_cache.c: cache_refresh_path:
search path: \192.168.1.80\files
[178710.653088] CIFS: fs/smb/client/dfs_cache.c: get_dfs_referral:
ipc=\\192.168.1.80\IPC$ referral=\192.168.1.80\files
[178710.653090] CIFS: fs/smb/client/smb2ops.c: smb2_get_dfs_refer:
path: \192.168.1.80\files
[178710.653110] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178710.653113] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=190
[178710.653119] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=166
[178710.653237] CIFS: fs/smb/client/connect.c: RFC1002 header 0x49
[178710.653241] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 0 offset 0
[178710.653243] CIFS: fs/smb/client/smb2misc.c: SMB2 len 73
[178710.653245] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=200
[178710.653252] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=11 mid=4 state=64
[178710.653263] CIFS: Status code returned 0xc0000225 STATUS_NOT_FOUND
[178710.653265] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000225 to POSIX err -2
[178710.653268] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.653270] CIFS: fs/smb/client/dfs.c: dfs_mount_share: no dfs
referral for \192.168.1.80\files: -2
[178710.653272] CIFS: fs/smb/client/dfs.c: dfs_mount_share: assuming
non-dfs mount...
[178710.653275] CIFS: fs/smb/client/connect.c: VFS: in cifs_get_tcon
as Xid: 1300 with uid: 0
[178710.653277] CIFS: fs/smb/client/smb2pdu.c: TCON
[178710.653280] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=199
[178710.653285] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=116
[178710.653472] CIFS: fs/smb/client/connect.c: RFC1002 header 0x50
[178710.653476] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178710.653478] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
64 credits total=263
[178710.653484] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=3 mid=5 state=64
[178710.653489] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.653491] CIFS: fs/smb/client/smb2pdu.c: connection to disk share
[178710.653493] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_tcon (xid = 1300) rc = 0
[178710.653495] CIFS: fs/smb/client/connect.c: Tcon rc = 0
[178710.653498] CIFS: fs/smb/client/smb2pdu.c: create/open
[178710.653501] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=262
[178710.653509] smb3_init_transform_rq: 28 callbacks suppressed
[178710.653510] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.653514] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=208
[178710.653758] CIFS: fs/smb/client/connect.c: RFC1002 header 0x104
[178710.653763] decrypt_raw_data: 50 callbacks suppressed
[178710.653764] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.653767] receive_encrypted_standard: 56 callbacks suppressed
[178710.653767] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.653769] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 56 offset 152
[178710.653771] CIFS: fs/smb/client/smb2misc.c: SMB2 len 208
[178710.653773] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=272
[178710.653790] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=5 mid=6 state=64
[178710.653794] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.653797] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178710.653799] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=271
[178710.653805] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.653810] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=177
[178710.654045] CIFS: fs/smb/client/connect.c: RFC1002 header 0x1d4
[178710.654050] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654052] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654054] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 304 offset 112
[178710.654055] CIFS: fs/smb/client/smb2misc.c: SMB2 len 416
[178710.654057] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=281
[178710.654069] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=11 mid=7 state=64
[178710.654073] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.81
[178710.654076] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 0
[178710.654078] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178710.654079] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178710.654081] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.80
[178710.654083] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 1
[178710.654085] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178710.654087] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178710.654089] CIFS: fs/smb/client/sess.c: referencing primary
channel iface: 192.168.1.80
[178710.654092] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 5
[178710.654095] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=280
[178710.654099] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654102] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=161
[178710.654207] CIFS: fs/smb/client/connect.c: RFC1002 header 0x90
[178710.654211] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654213] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654214] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 20 offset 72
[178710.654216] CIFS: fs/smb/client/smb2misc.c: SMB2 len 92
[178710.654218] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=290
[178710.654229] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=16 mid=8 state=64
[178710.654232] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.654234] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 4
[178710.654236] CIFS: fs/smb/client/transport.c:
wait_for_free_credits: remove 1 credits total=289
[178710.654240] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654243] CIFS: fs/smb/client/transport.c: Sending smb: smb_len=161
[178710.654311] CIFS: fs/smb/client/connect.c: RFC1002 header 0x84
[178710.654315] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654317] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654318] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 8 offset 72
[178710.654320] CIFS: fs/smb/client/smb2misc.c: SMB2 len 80
[178710.654322] CIFS: fs/smb/client/smb2ops.c: smb2_add_credits: added
10 credits total=299
[178710.654333] CIFS: fs/smb/client/transport.c: cifs_sync_mid_result:
cmd=16 mid=9 state=64
[178710.654335] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.654337] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 1
[178710.654341] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654409] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654411] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654413] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 28 offset 72
[178710.654423] CIFS: fs/smb/client/misc.c: Null buffer passed to
cifs_small_buf_release
[178710.654424] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 11
[178710.654427] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654486] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654487] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654488] CIFS: fs/smb/client/smb2misc.c: SMB2 data length 28 offset 72
[178710.654496] CIFS: fs/smb/client/smb2pdu.c: Close
[178710.654499] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654568] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654569] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654578] CIFS: fs/smb/client/connect.c: cifs_is_path_remote: full_path:
[178710.654579] CIFS: fs/smb/client/smb2pdu.c: create/open
[178710.654583] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654679] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654680] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654688] CIFS: fs/smb/client/smb2pdu.c: Close
[178710.654691] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654758] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654760] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654767] CIFS: fs/smb/client/smb2pdu.c: create/open
[178710.654770] CIFS: fs/smb/client/smb2ops.c: Encrypt message returned 0
[178710.654865] CIFS: fs/smb/client/smb2ops.c: Decrypt message returned 0
[178710.654866] CIFS: fs/smb/client/smb2ops.c: mid found
[178710.654874] CIFS: fs/smb/client/smb2pdu.c: Close
[178710.654953] cifs_ses_add_channel: 12 callbacks suppressed
[178710.654954] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1301 with uid: 0
[178710.654955] cifs_ses_add_channel: 12 callbacks suppressed
[178710.654956] CIFS: fs/smb/client/sess.c: adding channel to ses
00000000712933ff (speed:10000 bps rdma:no ip:192.168.1.81)
[178710.654959] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178710.654961] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178710.654968] CIFS: fs/smb/client/connect.c: Socket created
[178710.654969] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178710.655080] cifs_chan_set_need_reconnect: 12 callbacks suppressed
[178710.655081] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178710.655084] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7082
[178710.655086] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178710.657659] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178710.657670] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178710.657672] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178710.657676] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178710.657678] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178710.657680] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178710.657684] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178710.657686] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178710.657688] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178710.657690] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178710.657692] SMB2_sess_alloc_buffer: 12 callbacks suppressed
[178710.657692] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 5db3f57d
[178710.657842] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178710.657846] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000016 to POSIX err -5
[178710.657850] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178710.657853] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178710.657855] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 5db3f57d
[178710.664573] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178710.664577] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178710.664580] cifs_ses_add_channel: 12 callbacks suppressed
[178710.664581] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1301) rc = 0
[178710.664583] CIFS: successfully opened new channel on iface:192.168.1.81
[178710.664586] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount
(xid = 1297) rc = 0
[178710.664654] CIFS: fs/smb/client/inode.c: VFS: in cifs_root_iget as
Xid: 1302 with uid: 0
[178710.665037] CIFS: fs/smb/client/inode.c: looking for uniqueid=1310721
[178710.665046] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
revalidating inode 1310721
[178710.665048] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
inode 1310721 is new
[178710.665051] CIFS: fs/smb/client/inode.c: VFS: leaving
cifs_root_iget (xid = 1302) rc = 0
[178710.665055] CIFS: fs/smb/client/cifsfs.c: Get root dentry for
[178710.665057] CIFS: fs/smb/client/cifsfs.c: dentry root is: 00000000f2551bfc
+ cat case3-debugdata.txt
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.56
Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x25e Hostname: 192.168.1.80
ClientGUID: 7347979F-C19A-CF48-BAF5-751DF09E96CE
Number of credits: 362,1,1 Dialect 0x311 signed
Server capabilities: 0x30006f
TCP status: 1 Instance: 1
Local Users To Server: 2 SecMode: 0x3 Req On Wire: 0 Net namespace: 4026531833
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support
Encryption: Negotiated cipher (AES128-GCM)

    Sessions:
    1) Address: 192.168.1.80 Uses: 1 Capability: 0x30006f    Session Status: 1
    Security type: RawNTLMSSP  SessionId: 0x5db3f57d
    User: 0 Cred User: 0

    Extra Channels: 1

        Channel: 2 ConnectionId: 0x25f
        Number of credits: 155,1,1 Dialect 0x311
        TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        In Send: 0 In MaxReq Wait: 0 Net namespace: 4026531833

    Shares:
    0) IPC: \\192.168.1.80\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
    PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0
    Share Capabilities: None    Share Flags: 0x0
    tid: 0x55490b4c    Maximal Access: 0x1f00a9

    1) \\192.168.1.80\files Mounts: 1 DevInfo: 0x22 Attributes: 0x1006f
    PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0xe1c466ed encrypted
    Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x8000
    tid: 0xb6349ba    Optimal sector size: 0x200    Maximal Access: 0x1f00a9


    Server interfaces: 2    Last updated: 1 seconds ago
    1)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.81
        Weight (cur,total): (1,1)
        Allocated channels: 1
        [CONNECTED]

    2)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.80
        Weight (cur,total): (1,1)
        Allocated channels: 1
        [CONNECTED]


    MIDs:
--

+ ssh 192.168.1.80 cat /etc/samba/smb.conf
[global]
interfaces = "192.168.1.80;capability=RSS,speed=10000"
"192.168.1.81;capability=RSS,speed=10000"
workgroup = WORKGROUP
server role = standalone server
passdb backend = tdbsam
obey pam restrictions = yes
server signing = mandatory
server min protocol = SMB3_11
server multi channel support = yes

[files]
path = /files
public = no
writable = no
printable = no

server smb encrypt = required

+ echo END case3
END case3
+ echo

+ echo 'Case 4, client multichannel+seal, server has share-specific
encryption required'
Case 4, client multichannel+seal, server has share-specific encryption required
+ run_test case4 seal,multichannel,vers=3.1.1,user=user,password=user
+ CASE=case4
+ OPTS=seal,multichannel,vers=3.1.1,user=user,password=user
+ echo

+ echo BEGIN case4
BEGIN case4
+ ssh 192.168.1.80 cp /etc/samba/smb.conf-case4 /etc/samba/smb.conf
+ ssh 192.168.1.80 systemctl restart smbd
+ dmesg -c
+ sleep 1
+ mount.cifs -o seal,multichannel,vers=3.1.1,user=user,password=user
'\\192.168.1.80\files' /mnt
+ sleep 1
+ dmesg
+ cat /proc/fs/cifs/DebugData
+ umount /mnt
+ cat case4-dmesg.txt
[178713.302446] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'source'
[178713.302456] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'ip'
[178713.302460] CIFS: fs/smb/client/fs_context.c: CIFS: parsing cifs
mount option 'unc'
[178713.302468] CIFS: fs/smb/client/cifsfs.c: cifs_smb3_do_mount:
devname=//192.168.1.80/files flags=0x0
[178713.302472] CIFS: fs/smb/client/connect.c: file mode: 0755  dir mode: 0755
[178713.302475] CIFS: fs/smb/client/connect.c: VFS: in
cifs_mount_get_session as Xid: 1306 with uid: 0
[178713.302478] CIFS: fs/smb/client/connect.c: UNC: \\192.168.1.80\files
[178713.302481] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.80:445
[178713.302490] CIFS: fs/smb/client/connect.c: Socket created
[178713.302492] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178713.302939] CIFS: fs/smb/client/connect.c: VFS: in
cifs_get_smb_ses as Xid: 1307 with uid: 0
[178713.302939] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7096
[178713.302944] CIFS: fs/smb/client/connect.c: Existing smb sess not found
[178713.302951] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178713.307212] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178713.307254] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178713.307257] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178713.307262] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178713.307264] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178713.307265] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178713.307271] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x1
[178713.307274] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178713.307276] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178713.307277] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178713.307279] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178713.307592] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178713.307598] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000016 to POSIX err -5
[178713.307603] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178713.307605] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178713.307607] CIFS: fs/smb/client/smb2pdu.c: Fresh session. Previous: 0
[178713.317943] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178713.317948] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 0; now 0x0
[178713.317952] CIFS: fs/smb/client/connect.c: VFS: in cifs_setup_ipc
as Xid: 1308 with uid: 0
[178713.317955] CIFS: fs/smb/client/smb2pdu.c: TCON
[178713.318323] CIFS: fs/smb/client/smb2pdu.c: connection to pipe share
[178713.318327] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_setup_ipc (xid = 1308) rc = 0
[178713.318330] CIFS: fs/smb/client/connect.c: IPC tcon rc=0 ipc tid=0xf9ebf8d0
[178713.318332] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_smb_ses (xid = 1307) rc = 0
[178713.318335] CIFS: fs/smb/client/dfs_cache.c: cache_refresh_path:
search path: \192.168.1.80\files
[178713.318339] CIFS: fs/smb/client/dfs_cache.c: get_dfs_referral:
ipc=\\192.168.1.80\IPC$ referral=\192.168.1.80\files
[178713.318341] CIFS: fs/smb/client/smb2ops.c: smb2_get_dfs_refer:
path: \192.168.1.80\files
[178713.318344] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178713.318593] CIFS: Status code returned 0xc0000225 STATUS_NOT_FOUND
[178713.318598] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000225 to POSIX err -2
[178713.318602] CIFS: fs/smb/client/dfs.c: dfs_mount_share: no dfs
referral for \192.168.1.80\files: -2
[178713.318605] CIFS: fs/smb/client/dfs.c: dfs_mount_share: assuming
non-dfs mount...
[178713.318608] CIFS: fs/smb/client/connect.c: VFS: in cifs_get_tcon
as Xid: 1309 with uid: 0
[178713.318611] CIFS: fs/smb/client/smb2pdu.c: TCON
[178713.318897] CIFS: fs/smb/client/smb2pdu.c: connection to disk share
[178713.318900] CIFS: fs/smb/client/connect.c: VFS: leaving
cifs_get_tcon (xid = 1309) rc = 0
[178713.318908] CIFS: fs/smb/client/connect.c: Tcon rc = 0
[178713.318911] CIFS: fs/smb/client/smb2pdu.c: create/open
[178713.319218] CIFS: fs/smb/client/smb2pdu.c: SMB2 IOCTL
[178713.319460] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.81
[178713.319463] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 0
[178713.319465] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178713.319466] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178713.319468] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: ipv4 192.168.1.80
[178713.319470] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: adding iface 1
[178713.319472] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: speed 10000 bps
[178713.319474] CIFS: fs/smb/client/smb2ops.c:
parse_server_interfaces: capabilities 0x00000001
[178713.319476] CIFS: fs/smb/client/sess.c: referencing primary
channel iface: 192.168.1.80
[178713.319479] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 5
[178713.319607] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 4
[178713.319716] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 1
[178713.319821] CIFS: fs/smb/client/smb2pdu.c: Query FSInfo level 11
[178713.319925] CIFS: fs/smb/client/smb2pdu.c: Close
[178713.320030] CIFS: fs/smb/client/connect.c: cifs_is_path_remote: full_path:
[178713.320032] CIFS: fs/smb/client/smb2pdu.c: create/open
[178713.320170] CIFS: fs/smb/client/smb2pdu.c: Close
[178713.320252] CIFS: fs/smb/client/smb2pdu.c: create/open
[178713.320348] CIFS: fs/smb/client/smb2pdu.c: Close
[178713.320421] CIFS: fs/smb/client/sess.c: VFS: in
cifs_ses_add_channel as Xid: 1310 with uid: 0
[178713.320423] CIFS: fs/smb/client/sess.c: adding channel to ses
000000001de62484 (speed:10000 bps rdma:no ip:192.168.1.81)
[178713.320426] CIFS: fs/smb/client/connect.c: UNC: \192.168.1.80\foo
[178713.320428] CIFS: fs/smb/client/connect.c: generic_ip_connect:
connecting to 192.168.1.81:445
[178713.320434] CIFS: fs/smb/client/connect.c: Socket created
[178713.320435] CIFS: fs/smb/client/connect.c: sndbuf 16384 rcvbuf
131072 rcvtimeo 0x6d6
[178713.320546] CIFS: fs/smb/client/sess.c: Set reconnect bitmask for
chan 1; now 0x2
[178713.320549] CIFS: fs/smb/client/connect.c: Demultiplex PID: 7097
[178713.320555] CIFS: fs/smb/client/smb2pdu.c: Negotiate protocol
[178713.322867] CIFS: fs/smb/client/smb2misc.c: length of negcontexts 60 pad 6
[178713.322883] CIFS: fs/smb/client/smb2pdu.c: mode 0x3
[178713.322886] CIFS: fs/smb/client/smb2pdu.c: negotiated smb3.1.1 dialect
[178713.322890] CIFS: fs/smb/client/smb2pdu.c: decoding 2 negotiate contexts
[178713.322892] CIFS: fs/smb/client/smb2pdu.c: decode SMB3.11
encryption neg context of len 4
[178713.322894] CIFS: fs/smb/client/smb2pdu.c: SMB311 cipher type:2
[178713.322904] CIFS: fs/smb/client/connect.c: cifs_setup_session:
channel connect bitmap: 0x2
[178713.322907] CIFS: fs/smb/client/connect.c: Security Mode: 0x3
Capabilities: 0x30006f TimeAdjust: 0
[178713.322910] CIFS: fs/smb/client/smb2pdu.c: Session Setup
[178713.322911] CIFS: fs/smb/client/smb2pdu.c: sess setup type 2
[178713.322914] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 91124285
[178713.323087] CIFS: Status code returned 0xc0000016
STATUS_MORE_PROCESSING_REQUIRED
[178713.323091] CIFS: fs/smb/client/smb2maperror.c: Mapping SMB2
status code 0xc0000016 to POSIX err -5
[178713.323095] CIFS: fs/smb/client/sess.c: decode_ntlmssp_challenge:
negotiate=0xe2088235 challenge=0xe28a8235
[178713.323098] CIFS: fs/smb/client/smb2pdu.c: rawntlmssp session
setup challenge phase
[178713.323100] CIFS: fs/smb/client/smb2pdu.c: Binding to sess id: 91124285
[178713.329236] CIFS: fs/smb/client/smb2pdu.c: SMB2/3 session
established successfully
[178713.329240] CIFS: fs/smb/client/sess.c: Cleared reconnect bitmask
for chan 1; now 0x0
[178713.329243] CIFS: fs/smb/client/sess.c: VFS: leaving
cifs_ses_add_channel (xid = 1310) rc = 0
[178713.329245] CIFS: successfully opened new channel on iface:192.168.1.81
[178713.329248] CIFS: fs/smb/client/connect.c: VFS: leaving cifs_mount
(xid = 1306) rc = 0
[178713.329314] CIFS: fs/smb/client/inode.c: VFS: in cifs_root_iget as
Xid: 1311 with uid: 0
[178713.329627] CIFS: fs/smb/client/inode.c: looking for uniqueid=1310721
[178713.329634] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
revalidating inode 1310721
[178713.329636] CIFS: fs/smb/client/inode.c: cifs_revalidate_cache:
inode 1310721 is new
[178713.329639] CIFS: fs/smb/client/inode.c: VFS: leaving
cifs_root_iget (xid = 1311) rc = 0
[178713.329644] CIFS: fs/smb/client/cifsfs.c: Get root dentry for
[178713.329646] CIFS: fs/smb/client/cifsfs.c: dentry root is: 0000000060cfd520
[178713.598102] [TTM] Buffer eviction failed
+ cat case4-debugdata.txt
Display Internal CIFS Data Structures for Debugging
---------------------------------------------------
CIFS Version 2.56
Features: DFS,FSCACHE,STATS2,DEBUG,ALLOW_INSECURE_LEGACY,CIFS_POSIX,UPCALL(SPNEGO),XATTR,ACL
CIFSMaxBufSize: 16384
Active VFS Requests: 0

Servers:
1) ConnectionId: 0x260 Hostname: 192.168.1.80
ClientGUID: 6EFD9FFB-9969-3946-BB47-371D6BEED576
Number of credits: 362,1,1 Dialect 0x311 signed
Server capabilities: 0x30006f
TCP status: 1 Instance: 1
Local Users To Server: 2 SecMode: 0x3 Req On Wire: 0 Net namespace: 4026531833
In Send: 0 In MaxReq Wait: 0
Compression: no built-in support
Encryption: Negotiated cipher (AES128-GCM)

    Sessions:
    1) Address: 192.168.1.80 Uses: 1 Capability: 0x30006f    Session Status: 1
    Security type: RawNTLMSSP  SessionId: 0x91124285
    User: 0 Cred User: 0

    Extra Channels: 1

        Channel: 2 ConnectionId: 0x261
        Number of credits: 155,1,1 Dialect 0x311
        TCP status: 1 Instance: 1
        Local Users To Server: 1 SecMode: 0x3 Req On Wire: 0
        In Send: 0 In MaxReq Wait: 0 Net namespace: 4026531833

    Shares:
    0) IPC: \\192.168.1.80\IPC$ Mounts: 1 DevInfo: 0x0 Attributes: 0x0
    PathComponentMax: 0 Status: 1 type: 0 Serial Number: 0x0 encrypted
    Share Capabilities: None    Share Flags: 0x0
    tid: 0xf9ebf8d0    Maximal Access: 0x1f00a9

    1) \\192.168.1.80\files Mounts: 1 DevInfo: 0x22 Attributes: 0x1006f
    PathComponentMax: 255 Status: 1 type: DISK Serial Number:
0xe1c466ed encrypted
    Share Capabilities: None Aligned, Partition Aligned,    Share Flags: 0x8000
    tid: 0x907f4703    Optimal sector size: 0x200    Maximal Access: 0x1f00a9


    Server interfaces: 2    Last updated: 1 seconds ago
    1)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.81
        Weight (cur,total): (1,1)
        Allocated channels: 1
        [CONNECTED]

    2)    Speed: Unknown
        Capabilities: rss
        IPv4: 192.168.1.80
        Weight (cur,total): (1,1)
        Allocated channels: 1
        [CONNECTED]


    MIDs:
--

+ ssh 192.168.1.80 cat /etc/samba/smb.conf
[global]
interfaces = "192.168.1.80;capability=RSS,speed=10000"
"192.168.1.81;capability=RSS,speed=10000"
workgroup = WORKGROUP
server role = standalone server
passdb backend = tdbsam
obey pam restrictions = yes
server signing = mandatory
server min protocol = SMB3_11
server multi channel support = yes

[files]
path = /files
public = no
writable = no
printable = no

server smb encrypt = required

+ echo END case4
END case4
+ echo

root@client:~# exit
exit
