Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CCC7446A3;
	Mon, 29 Jan 2024 05:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706507053; cv=none; b=YY8pDaqIg7zdiJR3KGb15DcQtpMbpOyL5uT3VYNkUFqStCHBDFpR0M6CyjlBQfFubzJDdJOeefqENKRcQlNvrt+ON9WwvrNlcb0XFG7Mv+9whJALMmRj6hzq6WwkV19ppqmGIv2SPDNhHBWcFpY565psDOwpt6fnKC+N284cC5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706507053; c=relaxed/simple;
	bh=UKAsvocEeKAiwtgNwHf+OjEg9Dnpl0Djnoo2VDDBS/g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GgVx0TjXOYFlVc14dP43HiNt8ZO/wzJd4XQfntwM8cjuLrelpZqr7LpYval8LFHysmK6JE6OxMbvuWZ0zpJ7enQjOlgYUCf9YcWt3IAllI+eoyUlLwGSMhnXbgBuyEMZU9H1fTpIro2NBTrvGzol6LJCG41xlXSA7dTuHLwXAC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ClHrYCM/; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ClHrYCM/"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40SMcZDn030563;
	Mon, 29 Jan 2024 05:43:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=ngI35Lv/lTP0D7PAFPS/Ey48CZkaG2kwQAM25WR3oXc=;
 b=ClHrYCM/qxHM0+4KcBlzbM2wIK71UCjnmHaUAT6si5e8q3yHDTiY9liamB06i3Nd7Y8O
 N/+YT91S7YcafAJRNaABQwxogOh9CqXA2H0vXRyvO+dKEWy6deTGY9APxKEKP5uo8Oqs
 B7mFQWPUhb0pEy5otEVy9o+O5BQo4VG1fmqnK+Qsg2yY7nodMogkN3HGTCtG/LivhcE8
 LM6VRZtX5WtDbO4NUT7ff+orqefMdUJ0kTK6oXWhVSnlzAc+Lsq261f+Z1l3TZ1Ifbtm
 rC7lhZwbjOCi0PJHRA/veZsLeucm+47UifRozX98NeEfcy8NbSQXrt0P/LTLyU87PihZ vg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2axbb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 05:43:57 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40T4qO0E014564;
	Mon, 29 Jan 2024 05:43:46 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr954s88-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 29 Jan 2024 05:43:46 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40T5hk0O021381;
	Mon, 29 Jan 2024 05:43:46 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr954s7r-1;
	Mon, 29 Jan 2024 05:43:46 +0000
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: stable@vger.kernel.org
Cc: kovalev@altlinux.org, abuehaze@amazon.com, smfrench@gmail.com,
        greg@kroah.com, linux-cifs@vger.kernel.org, keescook@chromium.org,
        darren.kenny@oracle.com, pc@manguebit.com, nspmangalore@gmail.com,
        vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.10.y] cifs: fix off-by-one in SMB2_query_info_init()
Date: Sun, 28 Jan 2024 21:43:42 -0800
Message-ID: <20240129054342.2472454-1-harshit.m.mogalapalli@oracle.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_02,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401290039
X-Proofpoint-GUID: yEg7zu0a5Ennv_TuaS7_mUiGR57a0fP3
X-Proofpoint-ORIG-GUID: yEg7zu0a5Ennv_TuaS7_mUiGR57a0fP3

Bug: After mounting the cifs fs, it complains with Resource temporarily
unavailable messages.

[root@vm1 xfstests-dev]# ./check -g quick -s smb3
TEST_DEV=//<SERVER_IP>/TEST is mounted but not a type cifs filesystem
[root@vm1 xfstests-dev]# df
df: /mnt/test: Resource temporarily unavailable

Paul's analysis of the bug:

	Bug is related to an off-by-one in smb2_set_next_command() when
	the client attempts to pad SMB2_QUERY_INFO request -- since it isn't
	8 byte aligned -- even though smb2_query_info_compound() doesn't
	provide an extra iov for such padding.

	v5.10.y doesn't have

        eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")

	and the commit does

		if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
			     len > CIFSMaxBufSize))
			return -EINVAL;

	so sizeof(*req) will wrongly include the extra byte from
	smb2_query_info_req::Buffer making @len unaligned and therefore causing
	OOB in smb2_set_next_command().

Fixes: 203a412e52b5 ("smb: client: fix OOB in SMB2_query_info_init()")
Suggested-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This patch is only for v5.10.y stable kernel.
I have tested the patched kernel, after mounting it doesn't become
unavailable.

Context:
[1] https://lore.kernel.org/all/CAH2r5mv2ipr4KJfMDXwHgq9L+kGdnRd1C2svcM=PCoDjA7uALA@mail.gmail.com/#t

Note to Greg: This is alternative way to fix by not taking commit
eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
flex-arrays").
before applying this patch a patch in the queue needs to be removed: https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/queue-5.10/smb3-replace-smb2pdu-1-element-arrays-with-flex-arrays.patch

As I have stated in [1] I am unsure the which is the best way, but this
commit eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with
flex-arrays") is not in 5.15.y so I think we shouldn't queue it in
5.10.y
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 76679dc4e6328..514e2cf44d951 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3379,7 +3379,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = len;
+	iov[0].iov_len = len - 1;
 	return 0;
 }
 
-- 
2.34.1

