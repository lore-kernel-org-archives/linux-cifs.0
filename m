Return-Path: <linux-cifs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AEDC4338F
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 23:05:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D481560F6C
	for <linux-cifs@archiver.kernel.org>; Mon, 26 Jul 2021 23:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233643AbhGZWYv (ORCPT <rfc822;linux-cifs@archiver.kernel.org>);
        Mon, 26 Jul 2021 18:24:51 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:23059 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhGZWYu (ORCPT
        <rfc822;linux-cifs@vger.kernel.org>); Mon, 26 Jul 2021 18:24:50 -0400
Received: from epcas1p3.samsung.com (unknown [182.195.41.47])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210726230517epoutp0397e9fdb5bf373ea4e5ebace4e354e77c~VecKbCzUf2575225752epoutp03b
        for <linux-cifs@vger.kernel.org>; Mon, 26 Jul 2021 23:05:17 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210726230517epoutp0397e9fdb5bf373ea4e5ebace4e354e77c~VecKbCzUf2575225752epoutp03b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627340717;
        bh=svI57hh9Db5z0+QZH7F+8P+oRmPDY7UjJXkZEe6Igxk=;
        h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
        b=r6PwuYtsscEOL+wIuMqtgcduE7K3r845Z87rk2eTcWwjowZTWi9kUvh/N1k1KQqow
         Ozc1b16EIRNKkQMg7CJJpc2xvP2nvkdp8mjPCA7PR18HFJUSOUqqC6cBwjOnAyShic
         fq+lgP9FTR7cd6LjG2rTSHw2HDbbpSemfj3Ns/kc=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas1p4.samsung.com (KnoxPortal) with ESMTP id
        20210726230516epcas1p468b1b30d0dc678756878dd4d2a8a28a9~VecKP5XrA0208502085epcas1p4M;
        Mon, 26 Jul 2021 23:05:16 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.40.159]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4GYb9l5Ym1z4x9Q1; Mon, 26 Jul
        2021 23:05:15 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        58.3C.09551.AAF3FF06; Tue, 27 Jul 2021 08:05:14 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20210726230514epcas1p126cb0c09043146f82b29e7d2b0769fd4~VecHlnQVX1240012400epcas1p1v;
        Mon, 26 Jul 2021 23:05:14 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20210726230514epsmtrp25c779d75800d26c78f6a1947015c4305~VecHlAOws2602626026epsmtrp2d;
        Mon, 26 Jul 2021 23:05:14 +0000 (GMT)
X-AuditID: b6c32a36-2c9ff7000000254f-97-60ff3faa49da
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        B6.6E.08394.9AF3FF06; Tue, 27 Jul 2021 08:05:13 +0900 (KST)
Received: from namjaejeon01 (unknown [10.89.31.77]) by epsmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20210726230513epsmtip28702c7ec8393a2f66535d504ab9cf3d7~VecHbuwNE1442314423epsmtip2E;
        Mon, 26 Jul 2021 23:05:13 +0000 (GMT)
From:   "Namjae Jeon" <namjae.jeon@samsung.com>
To:     "'Dan Carpenter'" <dan.carpenter@oracle.com>
Cc:     <linux-cifs@vger.kernel.org>
In-Reply-To: <20210726114137.GA30721@kili>
Subject: RE: [bug report] ksmbd: fix unused err value in smb2_lock
Date:   Tue, 27 Jul 2021 08:05:13 +0900
Message-ID: <001b01d78272$b0b6c690$122453b0$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQI6vdbP5icOghekkTnbPjpkznEjXwG3S6pqqoGu8lA=
Content-Language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPKsWRmVeSWpSXmKPExsWy7bCmge4q+/8JBlufc1u8/jedxeLF/13M
        DkweH5/eYvH4vEkugCkqxyYjNTEltUghNS85PyUzL91WyTs43jne1MzAUNfQ0sJcSSEvMTfV
        VsnFJ0DXLTMHaLySQlliTilQKCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8DQoECvODG3uDQv
        XS85P9fK0MDAyBSoMiEno+XjZ9aCiUUVS8+vYW9gfOHbxcjJISFgIvFx7my2LkYuDiGBHYwS
        GxY8ZoVwPjFKtMz/ywLhfGOUOHhyOXsXIwdYy4lDRRDxvUBFr3qgil4wSpx5MIkFZC6bgK7E
        vz/72UBsEQEDiXsnX4DFmQUUJP5cvsAEYnMKaEl8/baTHcQWFnCS+LzwNVgNi4CqRG/TXEYQ
        m1fAUuLWvC5WCFtQ4uTMJ1Bz5CW2v53DDPGDgsTPp8tYIXZZSbT9PMEIUSMiMbuzjRnkOAmB
        W+wSU9YvYYJocJH4ObefDcIWlnh1fAs7hC0l8fndXqh4ucSJk7+g6mskNszbB/W9sUTPixIQ
        k1lAU2L9Ln2ICkWJnb/nQq3lk3j3tYcVoppXoqNNCKJEVaLv0mGogdISXe0f2CcwKs1C8tgs
        JI/NQvLALIRlCxhZVjGKpRYU56anFhsWGCHH9SZGcMrTMtvBOOntB71DjEwcjIcYJTiYlUR4
        HVb8ThDiTUmsrEotyo8vKs1JLT7EaAoM6onMUqLJ+cCkm1cSb2hqZGxsbGFiZm5maqwkzvst
        9muCkEB6YklqdmpqQWoRTB8TB6dUA5Nn4JeLs3RiPxw3r6w5s+4Q87SFUzRuzVhizlwxs2Pn
        vePy2++mz7FbePfzzHbRyACuxtUtWx9FbZYrPbokIdFm1bZi7pvbpr4slVnwtUbCo1BaraZz
        2svFBof4Eib+zZOSevns3fmMyqdMnyZvk/C527Om5HuZiU98gGy8VHLrlHPRb4vfRR7hFC/S
        UZZRK7p9heX/7JYEfY3ZfMnXy+wn3DXnKTmQLvyw+/+Og3Nm3zkbHeYs+Ex/zVZdWxY5z8bj
        B5n7s8tfm7c+nmjuteeDdHrKH13enTrr3JLOnjygddt/V+sN1Zz7fxnj9bftUWu/u27qQ3HF
        ZmWVHSUpEotDuS6Fb+p6flI/ucWSMUmJpTgj0VCLuag4EQB2iSnYAgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsWy7bCSvO5K+/8JButeWVi8/jedxeLF/13M
        DkweH5/eYvH4vEkugCmKyyYlNSezLLVI3y6BK6Pl42fWgolFFUvPr2FvYHzh28XIwSEhYCJx
        4lBRFyMXh5DAbkaJU4fPsXUxcgLFpSWOnTjDDFEjLHH4cDFEzTNGie0rjjOC1LAJ6Er8+7Mf
        rF5EwEDi3skXLCA2s4CCxJ/LF5hAbCGBaon3xw6C1XAKaEl8/baTHcQWFnCS+LzwNVg9i4Cq
        RG/TXLCZvAKWErfmdbFC2IISJ2c+YQG5gVlAT6JtIyPEeHmJ7W/nMEOcqSDx8+kyVogTrCTa
        fp6AqhGRmN3ZxjyBUXgWkkmzECbNQjJpFpKOBYwsqxglUwuKc9Nziw0LDPNSy/WKE3OLS/PS
        9ZLzczcxgsNeS3MH4/ZVH/QOMTJxMB5ilOBgVhLhdVjxO0GINyWxsiq1KD++qDQntfgQozQH
        i5I474Wuk/FCAumJJanZqakFqUUwWSYOTqkGpn08xQHrS34Fs4g6Mz8L3iLLrH0jQ60izup6
        8aO3asw7fr6OqZg+S3bfhas5ExYVzF7Ucyz1eQrfXE2vCR09Sj/LeuQjk9b9MlKILJnqvZyl
        r7Kwd9WXKR1bs+TMQ3dv9bvIx1ac0dz1Xr/aoXH+DBm5hxKsC0VXvOiLU/SqzZN3NeHkLG06
        PPPRzspVGu/YPs26uj3qZ3DE9bk702aUXGbLFLqXI/S8o7ozuV1QO4HfvmDLFa+tiTWr/SW/
        7XI7l2L25D4b8+MaaTfPG3EHef+95HG4qxh/7uZqrc87ufkPS7cbay/iXS/8Jixr5cSdovtb
        2PorL9co/Vmwq74t8unrhyufx6WdnMBTWmWhxFKckWioxVxUnAgAjrNNj+oCAAA=
X-CMS-MailID: 20210726230514epcas1p126cb0c09043146f82b29e7d2b0769fd4
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210726114156epcas1p4e34eb25899ecee5d6ba97d1b01ddda4e
References: <CGME20210726114156epcas1p4e34eb25899ecee5d6ba97d1b01ddda4e@epcas1p4.samsung.com>
        <20210726114137.GA30721@kili>
Precedence: bulk
List-ID: <linux-cifs.vger.kernel.org>
X-Mailing-List: linux-cifs@vger.kernel.org

> Hello Namjae Jeon,
Hi Dan,

> 
> The patch 96ad4ec51c06: "ksmbd: fix unused err value in smb2_lock"
> from Jul 13, 2021, leads to the following static checker warning:
> 
> 	fs/ksmbd/smb2pdu.c:6565 smb2_lock()
> 	warn: missing error code here? 'smb_flock_init()' failed.
Okay, I will fix it.

Thanks for your report!
> 
> fs/ksmbd/smb2pdu.c
>     6518 int smb2_lock(struct ksmbd_work *work)
>     6519 {
>     6520 	struct smb2_lock_req *req = work->request_buf;
>     6521 	struct smb2_lock_rsp *rsp = work->response_buf;
>     6522 	struct smb2_lock_element *lock_ele;
>     6523 	struct ksmbd_file *fp = NULL;
>     6524 	struct file_lock *flock = NULL;
>     6525 	struct file *filp = NULL;
>     6526 	int lock_count;
>     6527 	int flags = 0;
>     6528 	int cmd = 0;
>     6529 	int err = 0, i;
>     6530 	u64 lock_start, lock_length;
>     6531 	struct ksmbd_lock *smb_lock = NULL, *cmp_lock, *tmp, *tmp2;
>     6532 	struct ksmbd_conn *conn;
>     6533 	int nolock = 0;
>     6534 	LIST_HEAD(lock_list);
>     6535 	LIST_HEAD(rollback_list);
>     6536 	int prior_lock = 0;
>     6537
>     6538 	ksmbd_debug(SMB, "Received lock request\n");
>     6539 	fp = ksmbd_lookup_fd_slow(work,
>     6540 				  le64_to_cpu(req->VolatileFileId),
>     6541 				  le64_to_cpu(req->PersistentFileId));
>     6542 	if (!fp) {
>     6543 		ksmbd_debug(SMB, "Invalid file id for lock : %llu\n",
>     6544 			    le64_to_cpu(req->VolatileFileId));
>     6545 		rsp->hdr.Status = STATUS_FILE_CLOSED;
>     6546 		goto out2;
>     6547 	}
>     6548
>     6549 	filp = fp->filp;
>     6550 	lock_count = le16_to_cpu(req->LockCount);
>     6551 	lock_ele = req->locks;
>     6552
>     6553 	ksmbd_debug(SMB, "lock count is %d\n", lock_count);
>     6554 	if (!lock_count) {
>     6555 		rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     6556 		goto out2;
>     6557 	}
>     6558
>     6559 	for (i = 0; i < lock_count; i++) {
>     6560 		flags = le32_to_cpu(lock_ele[i].Flags);
>     6561
>     6562 		flock = smb_flock_init(filp);
>     6563 		if (!flock) {
>     6564 			rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
> --> 6565 			goto out;
>                                 ^^^^^^^^ Should this be an error code?
> 
> 
>     6566 		}
>     6567
>     6568 		cmd = smb2_set_flock_flags(flock, flags);
>     6569
>     6570 		lock_start = le64_to_cpu(lock_ele[i].Offset);
>     6571 		lock_length = le64_to_cpu(lock_ele[i].Length);
>     6572 		if (lock_start > U64_MAX - lock_length) {
>     6573 			pr_err("Invalid lock range requested\n");
>     6574 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
>     6575 			goto out;
> 
> Same for a bunch of these early gotos as well.
> 
>     6576 		}
>     6577
>     6578 		if (lock_start > OFFSET_MAX)
>     6579 			flock->fl_start = OFFSET_MAX;
>     6580 		else
>     6581 			flock->fl_start = lock_start;
>     6582
>     6583 		lock_length = le64_to_cpu(lock_ele[i].Length);
>     6584 		if (lock_length > OFFSET_MAX - flock->fl_start)
>     6585 			lock_length = OFFSET_MAX - flock->fl_start;
>     6586
>     6587 		flock->fl_end = flock->fl_start + lock_length;
>     6588
>     6589 		if (flock->fl_end < flock->fl_start) {
>     6590 			ksmbd_debug(SMB,
>     6591 				    "the end offset(%llx) is smaller than the start offset(%llx)\n",
>     6592 				    flock->fl_end, flock->fl_start);
>     6593 			rsp->hdr.Status = STATUS_INVALID_LOCK_RANGE;
>     6594 			goto out;
>     6595 		}
>     6596
>     6597 		/* Check conflict locks in one request */
>     6598 		list_for_each_entry(cmp_lock, &lock_list, llist) {
>     6599 			if (cmp_lock->fl->fl_start <= flock->fl_start &&
>     6600 			    cmp_lock->fl->fl_end >= flock->fl_end) {
>     6601 				if (cmp_lock->fl->fl_type != F_UNLCK &&
>     6602 				    flock->fl_type != F_UNLCK) {
>     6603 					pr_err("conflict two locks in one request\n");
>     6604 					rsp->hdr.Status =
>     6605 						STATUS_INVALID_PARAMETER;
>     6606 					goto out;
>     6607 				}
>     6608 			}
>     6609 		}
>     6610
>     6611 		smb_lock = smb2_lock_init(flock, cmd, flags, &lock_list);
>     6612 		if (!smb_lock) {
>     6613 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     6614 			goto out;
>     6615 		}
>     6616 	}
>     6617
>     6618 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
>     6619 		if (smb_lock->cmd < 0) {
>     6620 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     6621 			goto out;
>     6622 		}
>     6623
>     6624 		if (!(smb_lock->flags & SMB2_LOCKFLAG_MASK)) {
>     6625 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     6626 			goto out;
>     6627 		}
>     6628
>     6629 		if ((prior_lock & (SMB2_LOCKFLAG_EXCLUSIVE | SMB2_LOCKFLAG_SHARED) &&
>     6630 		     smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) ||
>     6631 		    (prior_lock == SMB2_LOCKFLAG_UNLOCK &&
>     6632 		     !(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK))) {
>     6633 			rsp->hdr.Status = STATUS_INVALID_PARAMETER;
>     6634 			goto out;
>     6635 		}
>     6636
>     6637 		prior_lock = smb_lock->flags;
>     6638
>     6639 		if (!(smb_lock->flags & SMB2_LOCKFLAG_UNLOCK) &&
>     6640 		    !(smb_lock->flags & SMB2_LOCKFLAG_FAIL_IMMEDIATELY))
>     6641 			goto no_check_cl;
>     6642
>     6643 		nolock = 1;
>     6644 		/* check locks in connection list */
>     6645 		read_lock(&conn_list_lock);
>     6646 		list_for_each_entry(conn, &conn_list, conns_list) {
>     6647 			spin_lock(&conn->llist_lock);
>     6648 			list_for_each_entry_safe(cmp_lock, tmp2, &conn->lock_list, clist) {
>     6649 				if (file_inode(cmp_lock->fl->fl_file) !=
>     6650 				    file_inode(smb_lock->fl->fl_file))
>     6651 					continue;
>     6652
>     6653 				if (smb_lock->fl->fl_type == F_UNLCK) {
>     6654 					if (cmp_lock->fl->fl_file == smb_lock->fl->fl_file &&
>     6655 					    cmp_lock->start == smb_lock->start &&
>     6656 					    cmp_lock->end == smb_lock->end &&
>     6657 					    !lock_defer_pending(cmp_lock->fl)) {
>     6658 						nolock = 0;
>     6659 						list_del(&cmp_lock->flist);
>     6660 						list_del(&cmp_lock->clist);
>     6661 						spin_unlock(&conn->llist_lock);
>     6662 						read_unlock(&conn_list_lock);
>     6663
>     6664 						locks_free_lock(cmp_lock->fl);
>     6665 						kfree(cmp_lock);
>     6666 						goto out_check_cl;
>     6667 					}
>     6668 					continue;
>     6669 				}
>     6670
>     6671 				if (cmp_lock->fl->fl_file == smb_lock->fl->fl_file) {
>     6672 					if (smb_lock->flags & SMB2_LOCKFLAG_SHARED)
>     6673 						continue;
>     6674 				} else {
>     6675 					if (cmp_lock->flags & SMB2_LOCKFLAG_SHARED)
>     6676 						continue;
>     6677 				}
>     6678
>     6679 				/* check zero byte lock range */
>     6680 				if (cmp_lock->zero_len && !smb_lock->zero_len &&
>     6681 				    cmp_lock->start > smb_lock->start &&
>     6682 				    cmp_lock->start < smb_lock->end) {
>     6683 					spin_unlock(&conn->llist_lock);
>     6684 					read_unlock(&conn_list_lock);
>     6685 					pr_err("previous lock conflict with zero byte lock range\n");
>     6686 					rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
>     6687 						goto out;
>     6688 				}
>     6689
>     6690 				if (smb_lock->zero_len && !cmp_lock->zero_len &&
>     6691 				    smb_lock->start > cmp_lock->start &&
>     6692 				    smb_lock->start < cmp_lock->end) {
>     6693 					spin_unlock(&conn->llist_lock);
>     6694 					read_unlock(&conn_list_lock);
>     6695 					pr_err("current lock conflict with zero byte lock range\n");
>     6696 					rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
>     6697 						goto out;
>     6698 				}
>     6699
>     6700 				if (((cmp_lock->start <= smb_lock->start &&
>     6701 				      cmp_lock->end > smb_lock->start) ||
>     6702 				     (cmp_lock->start < smb_lock->end &&
>     6703 				      cmp_lock->end >= smb_lock->end)) &&
>     6704 				    !cmp_lock->zero_len && !smb_lock->zero_len) {
>     6705 					spin_unlock(&conn->llist_lock);
>     6706 					read_unlock(&conn_list_lock);
>     6707 					pr_err("Not allow lock operation on exclusive lock range\n");
>     6708 					rsp->hdr.Status =
>     6709 						STATUS_LOCK_NOT_GRANTED;
>     6710 					goto out;
>     6711 				}
>     6712 			}
>     6713 			spin_unlock(&conn->llist_lock);
>     6714 		}
>     6715 		read_unlock(&conn_list_lock);
>     6716 out_check_cl:
>     6717 		if (smb_lock->fl->fl_type == F_UNLCK && nolock) {
>     6718 			pr_err("Try to unlock nolocked range\n");
>     6719 			rsp->hdr.Status = STATUS_RANGE_NOT_LOCKED;
>     6720 			goto out;
>     6721 		}
>     6722
>     6723 no_check_cl:
>     6724 		if (smb_lock->zero_len) {
>     6725 			err = 0;
>     6726 			goto skip;
>     6727 		}
>     6728
>     6729 		flock = smb_lock->fl;
>     6730 		list_del(&smb_lock->llist);
>     6731 retry:
>     6732 		err = vfs_lock_file(filp, smb_lock->cmd, flock, NULL);
>     6733 skip:
>     6734 		if (flags & SMB2_LOCKFLAG_UNLOCK) {
>     6735 			if (!err) {
>     6736 				ksmbd_debug(SMB, "File unlocked\n");
>     6737 			} else if (err == -ENOENT) {
>     6738 				rsp->hdr.Status = STATUS_NOT_LOCKED;
>     6739 				goto out;
>     6740 			}
>     6741 			locks_free_lock(flock);
>     6742 			kfree(smb_lock);
>     6743 		} else {
>     6744 			if (err == FILE_LOCK_DEFERRED) {
>     6745 				void **argv;
>     6746
>     6747 				ksmbd_debug(SMB,
>     6748 					    "would have to wait for getting lock\n");
>     6749 				spin_lock(&work->conn->llist_lock);
>     6750 				list_add_tail(&smb_lock->clist,
>     6751 					      &work->conn->lock_list);
>     6752 				spin_unlock(&work->conn->llist_lock);
>     6753 				list_add(&smb_lock->llist, &rollback_list);
>     6754
>     6755 				argv = kmalloc(sizeof(void *), GFP_KERNEL);
>     6756 				if (!argv) {
>     6757 					err = -ENOMEM;
>     6758 					goto out;
>     6759 				}
>     6760 				argv[0] = flock;
>     6761
>     6762 				err = setup_async_work(work,
>     6763 						       smb2_remove_blocked_lock,
>     6764 						       argv);
>     6765 				if (err) {
>     6766 					rsp->hdr.Status =
>     6767 					   STATUS_INSUFFICIENT_RESOURCES;
>     6768 					goto out;
>     6769 				}
>     6770 				spin_lock(&fp->f_lock);
>     6771 				list_add(&work->fp_entry, &fp->blocked_works);
>     6772 				spin_unlock(&fp->f_lock);
>     6773
>     6774 				smb2_send_interim_resp(work, STATUS_PENDING);
>     6775
>     6776 				ksmbd_vfs_posix_lock_wait(flock);
>     6777
>     6778 				if (work->state != KSMBD_WORK_ACTIVE) {
>     6779 					list_del(&smb_lock->llist);
>     6780 					spin_lock(&work->conn->llist_lock);
>     6781 					list_del(&smb_lock->clist);
>     6782 					spin_unlock(&work->conn->llist_lock);
>     6783 					locks_free_lock(flock);
>     6784
>     6785 					if (work->state == KSMBD_WORK_CANCELLED) {
>     6786 						spin_lock(&fp->f_lock);
>     6787 						list_del(&work->fp_entry);
>     6788 						spin_unlock(&fp->f_lock);
>     6789 						rsp->hdr.Status =
>     6790 							STATUS_CANCELLED;
>     6791 						kfree(smb_lock);
>     6792 						smb2_send_interim_resp(work,
>     6793 								       STATUS_CANCELLED);
>     6794 						work->send_no_response = 1;
>     6795 						goto out;
>     6796 					}
>     6797 					init_smb2_rsp_hdr(work);
>     6798 					smb2_set_err_rsp(work);
>     6799 					rsp->hdr.Status =
>     6800 						STATUS_RANGE_NOT_LOCKED;
>     6801 					kfree(smb_lock);
>     6802 					goto out2;
>     6803 				}
>     6804
>     6805 				list_del(&smb_lock->llist);
>     6806 				spin_lock(&work->conn->llist_lock);
>     6807 				list_del(&smb_lock->clist);
>     6808 				spin_unlock(&work->conn->llist_lock);
>     6809
>     6810 				spin_lock(&fp->f_lock);
>     6811 				list_del(&work->fp_entry);
>     6812 				spin_unlock(&fp->f_lock);
>     6813 				goto retry;
>     6814 			} else if (!err) {
>     6815 				spin_lock(&work->conn->llist_lock);
>     6816 				list_add_tail(&smb_lock->clist,
>     6817 					      &work->conn->lock_list);
>     6818 				list_add_tail(&smb_lock->flist,
>     6819 					      &fp->lock_list);
>     6820 				spin_unlock(&work->conn->llist_lock);
>     6821 				list_add(&smb_lock->llist, &rollback_list);
>     6822 				ksmbd_debug(SMB, "successful in taking lock\n");
>     6823 			} else {
>     6824 				rsp->hdr.Status = STATUS_LOCK_NOT_GRANTED;
>     6825 				goto out;
>     6826 			}
>     6827 		}
>     6828 	}
>     6829
>     6830 	if (atomic_read(&fp->f_ci->op_count) > 1)
>     6831 		smb_break_all_oplock(work, fp);
>     6832
>     6833 	rsp->StructureSize = cpu_to_le16(4);
>     6834 	ksmbd_debug(SMB, "successful in taking lock\n");
>     6835 	rsp->hdr.Status = STATUS_SUCCESS;
>     6836 	rsp->Reserved = 0;
>     6837 	inc_rfc1001_len(rsp, 4);
>     6838 	ksmbd_fd_put(work, fp);
>     6839 	return 0;
>     6840
>     6841 out:
>     6842 	list_for_each_entry_safe(smb_lock, tmp, &lock_list, llist) {
>     6843 		locks_free_lock(smb_lock->fl);
>     6844 		list_del(&smb_lock->llist);
>     6845 		kfree(smb_lock);
>     6846 	}
>     6847
>     6848 	list_for_each_entry_safe(smb_lock, tmp, &rollback_list, llist) {
>     6849 		struct file_lock *rlock = NULL;
>     6850 		int rc;
>     6851
>     6852 		rlock = smb_flock_init(filp);
>     6853 		rlock->fl_type = F_UNLCK;
>     6854 		rlock->fl_start = smb_lock->start;
>     6855 		rlock->fl_end = smb_lock->end;
>     6856
>     6857 		rc = vfs_lock_file(filp, 0, rlock, NULL);
>     6858 		if (rc)
>     6859 			pr_err("rollback unlock fail : %d\n", rc);
>     6860
>     6861 		list_del(&smb_lock->llist);
>     6862 		spin_lock(&work->conn->llist_lock);
>     6863 		if (!list_empty(&smb_lock->flist))
>     6864 			list_del(&smb_lock->flist);
>     6865 		list_del(&smb_lock->clist);
>     6866 		spin_unlock(&work->conn->llist_lock);
>     6867
>     6868 		locks_free_lock(smb_lock->fl);
>     6869 		locks_free_lock(rlock);
>     6870 		kfree(smb_lock);
>     6871 	}
>     6872 out2:
>     6873 	ksmbd_debug(SMB, "failed in taking lock(flags : %x)\n", flags);
>     6874 	smb2_set_err_rsp(work);
>     6875 	ksmbd_fd_put(work, fp);
>     6876 	return err;
>     6877 }
> 
> regards,
> dan carpenter

