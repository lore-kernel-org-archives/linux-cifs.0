Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64832576B;
	Sun, 28 Jan 2024 17:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706461699; cv=none; b=oXjuJpsgEgbZ4lNUlWMXB/NYvXHMTUr9X+wcOsov4HcYWZ270sMYD2qyEJ2LZTf3op1TfUQXDLekXigmwzEzvlweqJb03qR2kPuJ91c4A3Eas+PB2sMo12PBLSc7Ck/siXNUeTGAExkBL2IS8Cfsm2ZPv6sLWIYHNFJm6JYOMOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706461699; c=relaxed/simple;
	bh=RN1ndBrdmCaXUlaCSCgUlR4Hjpuvr36dqrPmiMBoUVg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iQYLLG5duV3v9xw4GTPeOU1gIbE2ZCx6I2PNGE0dAW03cxAk8zL83Z7FNypa9fwgJjEVtoCVTWw6ru/fG9Nji2d+eE5hV3U80QwSrzjtLrbQeBqc8Bg0o3SsLB5Zp3j2Vh7sFwRdKLec44FqaTPDiIqllG4q2ctVG1FLMTNhghk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mZ6LdCpZ; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mZ6LdCpZ"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40S2mTFC019768;
	Sun, 28 Jan 2024 17:08:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2023-11-20; bh=E8BkhYPP0et09N3ZNDoxFPmOnBqIyQ8ybwq+si+Xwi0=;
 b=mZ6LdCpZ1x26DB49K8FL/fo7FuqyXeEizXzUaPceid10mz5er7ifr+QK925hbl7wt/Uc
 76LdLj6apFzZhL67Z+VqaKAnQ//Rfd8IjPsfQ/5X7pGVZnrZf07X3koW9C++ukhG0GmZ
 9OVOc2vZazdM9noy/PY/VIxm3gIUXIM2RMSG98CrUSbN7ZoX+2EVB5DcwUEd/1Sovuz6
 a5e6sjTWuQ9Ll0jVWlr+uuYw8xpUq6/zI8YbXsCpsKnKNTLh0RqXxh6fAWEHfF5EpgpL
 Aof3+hIQXeB4jXZIg0qGPJiEAvlOq4S7Tnc1rkZl8mZ6E5xKGsuzAlYanT3PswYV1fwy +w== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvr8ea7sn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Jan 2024 17:08:06 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40SGU7sK014462;
	Sun, 28 Jan 2024 17:08:05 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr94rd67-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 28 Jan 2024 17:08:05 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40SH84Dc004976;
	Sun, 28 Jan 2024 17:08:04 GMT
Received: from ca-dev112.us.oracle.com (ca-dev112.us.oracle.com [10.129.136.47])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr94rd5x-1;
	Sun, 28 Jan 2024 17:08:04 +0000
From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
To: stable@vger.kernel.org
Cc: kovalev@altlinux.org, --cc=abuehaze@amazon.com, smfrench@gmail.com,
        greg@kroah.com, linux-cifs@vger.kernel.org, keescook@chromium.org,
        darren.kenny@oracle.com, pc@manguebit.com, nspmangalore@gmail.com,
        vegard.nossum@oracle.com,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Subject: [PATCH 5.15.y] cifs: fix off-by-one in SMB2_query_info_init()
Date: Sun, 28 Jan 2024 09:07:58 -0800
Message-ID: <20240128170759.2432089-1-harshit.m.mogalapalli@oracle.com>
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
 definitions=2024-01-25_14,2024-01-25_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401280129
X-Proofpoint-ORIG-GUID: tehZ8WNdbakKq3BYLmN_bmi90YTuLsuU
X-Proofpoint-GUID: tehZ8WNdbakKq3BYLmN_bmi90YTuLsuU

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

	v5.15.y doesn't have

        eb3e28c1e89b ("smb3: Replace smb2pdu 1-element arrays with flex-arrays")

	and the commit does

		if (unlikely(check_add_overflow(input_len, sizeof(*req), &len) ||
			     len > CIFSMaxBufSize))
			return -EINVAL;

	so sizeof(*req) will wrongly include the extra byte from
	smb2_query_info_req::Buffer making @len unaligned and therefore causing
	OOB in smb2_set_next_command().

Fixes: bfd18c0f570e4 ("smb: client: fix OOB in SMB2_query_info_init()")
Suggested-by: Paulo Alcantara <pc@manguebit.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
---
This patch is only for 5.15.y stable kernel.
I have tested the patched kernel: after mounting it doesn't become
unavailable.
---
 fs/cifs/smb2pdu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/smb2pdu.c b/fs/cifs/smb2pdu.c
index 6714e9db0ee83..b4b1d8132910c 100644
--- a/fs/cifs/smb2pdu.c
+++ b/fs/cifs/smb2pdu.c
@@ -3448,7 +3448,7 @@ SMB2_query_info_init(struct cifs_tcon *tcon, struct TCP_Server_Info *server,
 
 	iov[0].iov_base = (char *)req;
 	/* 1 for Buffer */
-	iov[0].iov_len = len;
+	iov[0].iov_len = len - 1;
 	return 0;
 }
 
-- 
2.34.1

