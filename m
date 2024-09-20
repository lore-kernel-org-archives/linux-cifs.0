Received: from stargate.chelsio.com (stargate.chelsio.com [12.32.117.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D05C1156F2B
	for <linux-cifs@vger.kernel.org>; Fri, 20 Sep 2024 13:57:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=12.32.117.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726840655; cv=none; b=AblGqvxdPe0tIvbgNmKCbfQZWtOUFyvs9CN6xRdWMjWYhMReqT/DnCq7KvD29QHHkv64Zs6cMvvnhbIOfRv/WveJDlJdAg7AYmiHUS8fmDXcahGYEI8eHVeCUixNVEPHKtEgNgp1eZs5WxgeFGM7TIr9Bga9sMTuSV3xqX+y6hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726840655; c=relaxed/simple;
	bh=zEIajb8OszG5QyoqFZDkV49mPbTEulfQyKQnT6zuJys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=fCM1ONb3b9FsCgcOCN9Tkkl2m9xwdJNkS+iTxkfxdwwgZ+qNnfSwuK0JZebRsWbsZZ+o8UG3P3NUW494u434jYGozRQEX2HlOc5lkm2PO2H5P6Sg8iGeHp94tq7MZ55QmqBBl4CGpja7Mh2MWJZikCpe3FYJQvQa7Q2yRw3DTF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com; spf=pass smtp.mailfrom=chelsio.com; arc=none smtp.client-ip=12.32.117.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=chelsio.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chelsio.com
Received: from sonada.blr.asicdesigners.com (sonada.blr.asicdesigners.com [10.193.186.190])
	by stargate.chelsio.com (8.14.7/8.14.7) with ESMTP id 48KDqEpI020079;
	Fri, 20 Sep 2024 06:52:15 -0700
From: Showrya M N <showrya@chelsio.com>
To: stfrench@microsoft.com, dhowells@redhat.com
Cc: showrya@chelsio.com, bharat@chelsio.com, linux-cifs@vger.kernel.org
Subject: connection reset observed while running iozone on single CIFS over rdma share
Date: Fri, 20 Sep 2024 19:37:06 +0530
Message-Id: <20240920140706.8452-1-showrya@chelsio.com>
X-Mailer: git-send-email 2.39.1
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Steve and David,

On internal testing of CIFS over RDMA ,the cliet[linux] is getting reset and its giving `Cannot open temporary file for read` error.

Upon further debugging, we found that the QP is transitioning from the RTS state to the ERROR state due to a peer_abort and kernel bisect points to commit d08089f649a0cfb2099c8551ac47eef0cc23fdf2 ("cifs: Change the I/O paths to use an iterator rather than a page list"). Since this commit represents a significant change with respect to CIFS, I need some help understanding how it affects RDMA.

Note: issue seen with both iWARP and RoCE.

-----------------------------------------------------------------------------------------------------------
Here is the testcase:
Server - windows [machine info: windows server 2022, drivers: Chelsio 6.16.20.0, Mellanox 2.42.22627.0]
Client - linux [kernel v6.11]

on windows: 
-> two cifs shares were created in Windows as below (sh1 and sh2)

PS C:\Windows\system32> Get-SmbShare

Name   ScopeName Path       Description
----   --------- ----       -----------
sh1    *         C:\share1
sh2    *         C:\share2

try mount on linux: #mount -o rdma,username=<username>,password=<password> //102.1.1.222/share1 /mount1
-----------------------------------------------------------------------------------------------------------

iozone test error:
[root@core mount1]# iozone -a -+d -I
            2048     512  257447  266769   269650   266108  267467  262771  264120   265935   251500  3169944  3229534 2998435  3573472
            2048    1024  294591  302869   311254   313434  314248  292156
Can not open temporary file for read
open: Resource temporarily unavailable
[root@core mount1]#


dmesg from linux machine:
[  886.136758] CIFS: No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3.1.1), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3.1.1 (or even SMB3 or SMB2.1) specify vers=1.0 on mount.
[  886.136767] CIFS: Attempting to mount //102.50.50.67/sh2
[  886.136828] CIFS: smbd_conn_upcall: event->event 0
[  886.136886] CIFS: smbd_conn_upcall: event->event 2
[  886.142392] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  886.143248] CIFS: smbd_conn_upcall: event->event 8
[  886.143314] CIFS: VFS: _smbd_get_connection:1634 rdma_connect failed port=5445
[  886.146682] CIFS: smbd_conn_upcall: event->event 0
[  886.146703] CIFS: smbd_conn_upcall: event->event 2
[  886.151900] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  886.153598] CIFS: smbd_conn_upcall: event->event 9
[  886.167331] CIFS: VFS: RDMA transport established
[  886.211612] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[  886.211619] CIFS: VFS: Session Id    05 00 00 00 00 e8 00 00
[  886.211622] CIFS: VFS: Cipher type   2
[  886.211624] CIFS: VFS: Session Key   13 54 03 6e 28 5f 85 8e 22 d1 37 31 c8 8f 3c 96
[  886.211626] CIFS: VFS: Signing Key   31 8a d7 79 2d 66 fa 98 d5 85 05 9d 58 df 96 88
[  886.211628] CIFS: VFS: ServerIn Key  45 10 c5 17 fa 30 fc 17 a2 17 5d 6c 20 cd 56 ac
[  886.211630] CIFS: VFS: ServerOut Key b1 ae 49 12 d6 5e c9 b0 16 d9 7d b5 8f 81 4f 30
[  915.835418] CIFS: smbd_conn_upcall: event->event 10
[  915.835434] CIFS: smbd_conn_upcall: info->transport_status 2
[  915.835496] CIFS: smbd_recv_buf: info->transport_status 5
[  915.835504] CIFS: VFS: smbd_recv_buf:1865 disconnected
[  915.835515] CIFS: smbd_destroy: info->transport_status 5
[  915.836349] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  915.836563] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  915.836618] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  915.836754] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  915.836796] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  915.849813] CIFS: smbd_conn_upcall: event->event 0
[  915.849858] CIFS: smbd_conn_upcall: event->event 2
[  915.852292] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  915.852570] CIFS: smbd_conn_upcall: event->event 8
[  915.852603] CIFS: VFS: _smbd_get_connection:1634 rdma_connect failed port=5445
[  915.854699] CIFS: smbd_conn_upcall: event->event 0
[  915.854725] CIFS: smbd_conn_upcall: event->event 2
[  915.858993] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  915.859898] CIFS: smbd_conn_upcall: event->event 9
[  915.872536] CIFS: VFS: RDMA transport re-established
[  915.874417] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[  915.874424] CIFS: VFS: Session Id    09 00 00 00 00 e8 00 00
[  915.874427] CIFS: VFS: Cipher type   2
[  915.874430] CIFS: VFS: Session Key   74 a5 36 e6 dd db 13 16 2b 84 1f a5 6f b2 85 1d
[  915.874433] CIFS: VFS: Signing Key   35 b4 96 d0 60 a5 74 2d ff c5 a6 ed c0 34 ab 1c
[  915.874436] CIFS: VFS: ServerIn Key  2b 7b d4 a0 67 d2 64 c3 20 df 6b 15 17 ae 00 b0
[  915.874439] CIFS: VFS: ServerOut Key d6 a2 53 c2 a7 19 9f 40 81 34 2c ae 91 84 ba d9
[  916.091622] CIFS: smbd_conn_upcall: event->event 10
[  916.091631] CIFS: smbd_conn_upcall: info->transport_status 2
[  916.091702] CIFS: smbd_recv_buf: info->transport_status 5
[  916.091711] CIFS: VFS: smbd_recv_buf:1865 disconnected
[  916.091721] CIFS: smbd_destroy: info->transport_status 5
[  916.092228] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  916.092334] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  916.092421] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  916.092502] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  916.092620] CIFS: smbd_disconnect_rdma_work: info->transport_status = SMBD_DISCONNECTING
[  916.102309] CIFS: smbd_conn_upcall: event->event 0
[  916.102335] CIFS: smbd_conn_upcall: event->event 2
[  916.103772] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  916.103960] CIFS: smbd_conn_upcall: event->event 8
[  916.103973] CIFS: VFS: _smbd_get_connection:1634 rdma_connect failed port=5445
[  916.105455] CIFS: smbd_conn_upcall: event->event 0
[  916.105472] CIFS: smbd_conn_upcall: event->event 2
[  916.108732] ib_core: ib_modify_mad: IB_WC_WR_FLUSH_ERR line 2480
[  916.109355] CIFS: smbd_conn_upcall: event->event 9
[  916.119471] CIFS: VFS: RDMA transport re-established
[  916.120926] CIFS: VFS: generate_smb3signingkey: dumping generated AES session keys
[  916.120934] CIFS: VFS: Session Id    0d 00 00 00 00 e8 00 00
[  916.120938] CIFS: VFS: Cipher type   2
[  916.120941] CIFS: VFS: Session Key   61 0c 9b e7 1c e2 bb 43 fe 18 23 03 45 ca f8 2d
[  916.120944] CIFS: VFS: Signing Key   09 b6 b2 f3 19 ab e1 65 d7 9f d4 31 8c 1f a9 64
[  916.120946] CIFS: VFS: ServerIn Key  75 b9 a0 cc d0 7a 25 ef 71 84 44 e8 90 40 a1 cc
[  916.120949] CIFS: VFS: ServerOut Key 3a bd 5e fd 83 95 1e 12 58 d0 2b 1f 81 d9 22 97



Bisect logs:
[root@beag linux]# git bisect start
HEAD is now at 457391b03803 Linux 6.3
[root@beag linux]# git bisect bad 457391b0380335d5e9a5babdec90ac53928b23b4
[root@beag linux]# git bisect good 4ec5183ec48656cec489c49f989c508b68b518e3
Bisecting: 7399 revisions left to test after this (roughly 13 steps)
[a5c95ca18a98d742d0a4a04063c32556b5b66378] Merge tag 'drm-next-2023-02-23' of git://anongit.freedesktop.org/drm/drm
[root@beag linux]# git bisect bad
Bisecting: 5053 revisions left to test after this (roughly 12 steps)
[36289a03bcd3aabdf66de75cb6d1b4ee15726438] Merge tag 'v6.3-p1' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6
[root@beag linux]# git bisect good
Bisecting: 2521 revisions left to test after this (roughly 11 steps)
[0175ec3a28c695562a08fdccf73f2ec5ed744e2f] Merge tag 'regulator-v6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator
[root@beag linux]# git bisect good
Bisecting: 1260 revisions left to test after this (roughly 10 steps)
[60b07cf5d3462ec0183d463b43619e98bc63c951] drm/amd/display: Make variables declaration inside ifdef guard
[root@beag linux]# git bisect good
Bisecting: 647 revisions left to test after this (roughly 9 steps)
[6861eaf79155f0a5544ff989754159f806795c31] Merge tag 'ata-6.3-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/dlemoal/libata
[root@beag linux]# git bisect good
Bisecting: 306 revisions left to test after this (roughly 8 steps)
[9fc2f99030b55027d84723b0dcbbe9f7e21b9c6c] Merge tag 'nfsd-6.3' of git://git.kernel.org/pub/scm/linux/kernel/git/cel/linux
[root@beag linux]# git bisect good
Bisecting: 163 revisions left to test after this (roughly 7 steps)
[535cd7104b4efacab3bf7e56b8ad263e1160a47f] Merge tag 'drm-msm-next-2023-01-30' of https://gitlab.freedesktop.org/drm/msm into drm-next
[root@beag linux]# git bisect good
Bisecting: 78 revisions left to test after this (roughly 6 steps)
[5582f3c1b14e9b6eb02983acac84a4da71b38ca9] Merge tag 'drm-intel-next-fixes-2023-02-17' of git://anongit.freedesktop.org/drm/drm-intel into drm-next
[root@beag linux]# git bisect good
Bisecting: 39 revisions left to test after this (roughly 5 steps)
[d08089f649a0cfb2099c8551ac47eef0cc23fdf2] cifs: Change the I/O paths to use an iterator rather than a page list
[root@beag linux]# git bisect bad
Bisecting: 19 revisions left to test after this (roughly 4 steps)
[35235e19b393b54db0e0d7c424d658ba45f20468] cifs: Replace remaining 1-element arrays
[root@beag linux]# git bisect good
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[f62e52d1276b6cd329fe72d36bdf912b2ce4caaf] iov_iter: Define flags to qualify page extraction.
[root@beag linux]# git bisect good
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[0185846975339a5c348373aa450a977f5242366b] netfs: Add a function to extract an iterator into a scatterlist
[root@beag linux]# git bisect good
Bisecting: 2 revisions left to test after this (roughly 1 step)
[39bc58203f040ebafbec48198a83c246b25eba99] cifs: Add a function to Hash the contents of an iterator
[root@beag linux]# git bisect good
Bisecting: 0 revisions left to test after this (roughly 1 step)
[16541195c6d9bcad568b7c6afbf855ddc3a856aa] cifs: Add a function to read into an iter from a socket
[root@beag linux]# git bisect good
d08089f649a0cfb2099c8551ac47eef0cc23fdf2 is the first bad commit
commit d08089f649a0cfb2099c8551ac47eef0cc23fdf2
Author: David Howells <dhowells@redhat.com>
Date:   Mon Jan 24 21:13:24 2022 +0000


    cifs: Change the I/O paths to use an iterator rather than a page list

 

    Currently, the cifs I/O paths hand lists of pages from the VM interface
    routines at the top all the way through the intervening layers to the
    socket interface at the bottom.

 

    This is a problem, however, for interfacing with netfslib which passes an
    iterator through to the ->issue_read() method (and will pass an iterator
    through to the ->issue_write() method in future).  Netfslib takes over
    bounce buffering for direct I/O, async I/O and encrypted content, so cifs
    doesn't need to do that.  Netfslib also converts IOVEC-type iterators into
    BVEC-type iterators if necessary.

 

    Further, cifs needs foliating - and folios may come in a variety of sizes,
    so a page list pointing to an array of heterogeneous pages may cause
    problems in places such as where crypto is done.

 

    Change the cifs I/O paths to hand iov_iter iterators all the way through
    instead.

 

    Notes:

 

     (1) Some old routines are #if'd out to be removed in a follow up patch so
         as to avoid confusing diff, thereby making the diff output easier to
         follow.  I've removed functions that don't overlap with anything
         added.

 

     (2) struct smb_rqst loses rq_pages, rq_offset, rq_npages, rq_pagesz and
         rq_tailsz which describe the pages forming the buffer; instead there's
         an rq_iter describing the source buffer and an rq_buffer which is used
         to hold the buffer for encryption.

 

     (3) struct cifs_readdata and cifs_writedata are similarly modified to
         smb_rqst.  The ->read_into_pages() and ->copy_into_pages() are then
         replaced with passing the iterator directly to the socket.

 

         The iterators are stored in these structs so that they are persistent
         and don't get deallocated when the function returns (unlike if they
         were stack variables).

 

     (4) Buffered writeback is overhauled, borrowing the code from the afs
         filesystem to gather up contiguous runs of folios.  The XARRAY-type
         iterator is then used to refer directly to the pagecache and can be
         passed to the socket to transmit data directly from there.

 

         This includes:

 

            cifs_extend_writeback()
            cifs_write_back_from_locked_folio()
            cifs_writepages_region()
            cifs_writepages()

 

     (5) Pages are converted to folios.

 

     (6) Direct I/O uses netfs_extract_user_iter() to create a BVEC-type
         iterator from an IOBUF/UBUF-type source iterator.

 

     (7) smb2_get_aead_req() uses netfs_extract_iter_to_sg() to extract page
         fragments from the iterator into the scatterlists that the crypto
         layer prefers.

 

     (8) smb2_init_transform_rq() attached pages to smb_rqst::rq_buffer, an
         xarray, to use as a bounce buffer for encryption.  An XARRAY-type
         iterator can then be used to pass the bounce buffer to lower layers.

 

    Signed-off-by: David Howells <dhowells@redhat.com>
    Signed-off-by: Steve French <stfrench@microsoft.com>


Thanks,
Showrya
