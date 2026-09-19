Received: from oss.cyber.gouv.fr (oss.cyber.gouv.fr [51.159.188.251])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BAF2D97B7;
	Sat, 19 Sep 2026 16:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.159.188.251
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789837179; cv=none; b=UHWuxm0ZlJj9vGHAztk8Hth5jDt9tJzSK8Ma3UsM9MAmF++g3s26A5hCic7rTPI5haJNqUC3bcoyOqy31iA9VnPjFLRQNQ0yZsVSB4vlyt6f9W7Rwj6rnw/+sHXSgREKpEBREo4JcWfdcfkdUwUJxBJwQaOiagZJoe29z83JIXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789837179; c=relaxed/simple;
	bh=5Al95Vq3AWaglLWATD0mG/bxgxndiPRMDmAY7/PQG9s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=D/fMON3r5Pd7wKfXF7pgd848Gy9x2NdjIBMn8aUnizTSFvREBazzbb97bxaMJ4GGUarPYuIxObpNMNkpVLkt5ODBhoBv8BRLGxqG8iiQeIMcdpI1s7EkG0k0DB7YRetVyzSK7X2HzR9aEA9K8aOLOAX9DBWyMqgwqq/UOzrhUIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr; spf=pass smtp.mailfrom=oss.cyber.gouv.fr; dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b=c0KCrDLf; arc=none smtp.client-ip=51.159.188.251
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.cyber.gouv.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oss.cyber.gouv.fr header.i=@oss.cyber.gouv.fr header.b="c0KCrDLf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=oss.cyber.gouv.fr; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PC8nBWYH0Iq7vpvdPWc52um2m35Kp0+jqL/05Xe6Ym8=; b=c0KCrDLfUQSiJSZDNpgnoBiI1G
	zd55MvyybnjliVrYh1pBplIEh4WwWCBqiW7VTJv3kszlpBznHHKqV8ifzEg55RyYOX+X4bUAsDMxO
	0S9pEVtR+emoK/5MHoJEkGkTTluFKuzj2fMUyuPt+gyr42COKForaYn5sblKnt4b0h52+1ZzxGqmN
	FV949+LU62NWqYfZ+ny5xpmMN3foc7a95itrbb4BOLVrho84pfsz+vxdfoh8LLXqaU2XEjTySP6Yo
	sqjbSunA6jNCyUVuun5ep6pqZMsMFu1xwjhVWvyJ/nlWT8J+W4WCXoi4RaB0sH/rU9Nk8rRt7htQ5
	AJT+aRgQ==;
Received: from [151.115.150.205] (port=58906 helo=gepetto..)
	by pf-012.whm.fr-par.scw.cloud with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.100)
	(envelope-from <Jeremy.Jean@oss.cyber.gouv.fr>)
	id 1x7yPT-000000000Zy-24Bl;
	Sat, 19 Sep 2026 18:59:29 +0200
From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
To: linkinjeon@kernel.org
Cc: senozhatsky@chromium.org,
	tom@talpey.com,
	chenxiaosong@chenxiaosong.com,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>
Subject: [PATCH] ksmbd: fix SMB2 CREATE response buffer overflow
Date: Sat, 19 Sep 2026 16:58:29 +0000
Message-ID: <20260919165828.2230488-2-Jeremy.Jean@oss.cyber.gouv.fr>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - pf-012.whm.fr-par.scw.cloud
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - oss.cyber.gouv.fr
X-Get-Message-Sender-Via: pf-012.whm.fr-par.scw.cloud: authenticated_id: jeremy.jean@oss.cyber.gouv.fr
X-Authenticated-Sender: pf-012.whm.fr-par.scw.cloud: jeremy.jean@oss.cyber.gouv.fr
X-Source: 
X-Source-Args: 
X-Source-Dir: 

smb2_allocate_rsp_buf() uses the MAX_CIFS_SMALL_BUFFER_SIZE
(448-byte) buffer for a single SMB2_CREATE response. That buffer also
holds a 4-byte length field, which only leaves 444 bytes for the SMB2
body.

The AAPL response made this buffer too small. After 8f1b796ff113, a
request with AAPL response contexts may need at least 456 bytes. In
the 456-byte case, create_aapl_rsp_buf() is appended last, clears 128
bytes, and writes 12 bytes past the allocation.

KASAN reports:

    BUG: KASAN: slab-out-of-bounds in create_aapl_rsp_buf+0x31/0x6e0
    Write of size 128 at addr ffff88800370954c by task kworker/0:0/9
    ...
    create_aapl_rsp_buf+0x31/0x6e0
    smb2_open+0x58f9/0xef10
    ...
    smb2_allocate_rsp_buf+0x19d/0x370
    ...
    The buggy address is located 332 bytes inside of
     allocated 448-byte region [ffff888003709400, ffff8880037095c0)

Reserve enough space for any fixed CREATE response KSMBD can build. This
keeps the small buffer for other commands and avoids using the max
transaction buffer for every CREATE.

Fixes: 8f1b796ff113 ("ksmbd: add AAPL kAAPL_SERVER_QUERY create context support")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
---
 fs/smb/server/smb2pdu.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/smb2pdu.c b/fs/smb/server/smb2pdu.c
index b7ce67094626..24a3fd463be0 100644
--- a/fs/smb/server/smb2pdu.c
+++ b/fs/smb/server/smb2pdu.c
@@ -860,14 +860,37 @@ static void smb2_update_lock_sequence(struct ksmbd_work *work,
 int smb2_allocate_rsp_buf(struct ksmbd_work *work)
 {
 	struct smb2_hdr *hdr = smb_get_msg(work->request_buf);
+	struct smb_version_values *vals = work->conn->vals;
 	size_t small_sz = MAX_CIFS_SMALL_BUFFER_SIZE;
-	size_t large_sz = small_sz + work->conn->vals->max_trans_size;
+	size_t large_sz = small_sz + vals->max_trans_size;
 	size_t sz = small_sz;
 	int cmd = le16_to_cpu(hdr->Command);
 
 	if (cmd == SMB2_IOCTL_HE || cmd == SMB2_QUERY_DIRECTORY_HE)
 		sz = large_sz;
 
+	if (cmd == SMB2_CREATE_HE) {
+		size_t create_sz;
+
+		/*
+		 * A CREATE response may contain any combination of fixed
+		 * response contexts. Account for the 4-byte length field
+		 * because work->response_sz includes it while smb_get_msg()
+		 * skips over it.
+		 */
+		create_sz = sizeof(__be32) +
+			    offsetof(struct smb2_create_rsp, Buffer);
+		create_sz += vals->create_lease_size;
+		create_sz += max_t(size_t,
+				   vals->create_durable_size,
+				   vals->create_durable_v2_size);
+		create_sz += vals->create_mxac_size;
+		create_sz += vals->create_disk_id_size;
+		create_sz += vals->create_posix_size;
+		create_sz += vals->create_aapl_size;
+		sz = max_t(size_t, sz, create_sz);
+	}
+
 	if (cmd == SMB2_QUERY_INFO_HE) {
 		struct smb2_query_info_req *req;
 
-- 
2.47.3

