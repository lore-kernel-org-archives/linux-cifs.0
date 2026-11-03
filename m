Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793746824;
	b=hb1Xgu0zJAy2myCoXW7CyLXTCC2m2t+Qdmlc8LMvTVQO7q+nf47uDEsp0EcXXuPhtuEj
	 lZ3eLMM+CtFYzW0tg8ZQ9kzmG/jcGcE/+Q8CiXZFIrvlOZsleR6z/fiK/8mUNtI6cCoSh
	 JDlZrkp2gzsOJjJKtAEHd2lLcobN+PTJ1ONVAlrds+9sRvTGamoQTo4+dgKXPgYyZ5oUL
	 3j3RlUOBnM8WkvpjDUHLD5oTCbeHgHQbbLlFkpnfiIhXC1G8FV4DR/KSACgXIbGLaYCN7
	 b9EasUwlR/xOm/K2AsD+Ov/3hLXribn/Sichg06MOWYkeNIMqV5Xm+66a0Isnd6aEEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793746824;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=56ajtd/v84dVv+akWEBhVvPYrZBPjRZRUFTb/qpj5cU=;
	b=eU1fne1obcITpwTLoecH/3L3OW/d66fubg6qPKea6SDT4S3mgd05Fa3VbwarA+BKDHgp
	 q1B31N8pszHEoTN41ec+tlBiOUf98zyGAPQ+JSGJSwd6Wpj2C+CpVtDfgghG/c8EUIBn7
	 TjoJuqVrKNRebg7M/tXbJCjj5ql/fV08ZtTrBdB3yLLR+5lbJjyc48KNX4Js+fp49auFA
	 vUIauDW4xkO9GJuDJmA0QsJAp732HWbcf3ENt0V/kCL5fGy00qPF/lKtumIJoRKIYGL6D
	 7RIOhVRlHs+p1J0WYaS2sYe/hmHBq/Unq6oQTsUu3V6LYGlvo8o0HgML2DL41FmzL7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b="8ZZJv/Ti";
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2451F606A32E;
	Tue,  3 Nov 2026 23:00:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2451F606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=8ZZJv/Ti
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=56ajtd/v84dVv+akWEBhVvPYrZBPjRZRUFTb/qpj5cU=; b=8ZZJv/Ti5LtNtARTd7olXGOMf9
	DqbieO1gHhIdA/dtXF/Tva3KvUZpsnQnzRo8k0h6sxxPfm72m5mATr01AOx24EY4yQlTavuApGnZe
	ascdiSzoDvdkKlHYin7L4DA8AYleh9ASS5L8VAeCP7idAeq6mzFBk9am5ANXO6oSheTXM8AaKCOXQ
	VNklIiXqMvFX7rUVMQ4hj/lbuumZ39jRf6WG1NX8uKJtYPcsHuqbB/FoAB/wTAOTAa2dTvPy6ZKul
	ZIfPTOOW2ZFdYmBdNxtJv7nvE3BMu3UwEwO/KFEpn5VUlAlRK8p7aFnWRpZU7oRmpDYJOYFplnCSe
	J4XGVVlg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xONUL-00000000kN8-21Nd;
	Tue, 03 Nov 2026 20:00:22 -0300
From: Paulo Alcantara <pc@manguebit.org>
To: linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	David Howells <dhowells@redhat.com>
Cc: Namjae Jeon <linkinjeon@kernel.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Tom Talpey <tom@talpey.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Christian Brauner <brauner@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v3 06/16] smb: client: don't retry failed writes forever regardless of mount options
Date: Tue,  3 Nov 2026 20:00:10 -0300
Message-ID: <20261103230020.1617748-7-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261103230020.1617748-1-pc@manguebit.org>
References: <20261103230020.1617748-1-pc@manguebit.org>
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Post: <mailto:linux-cifs@vger.kernel.org>
List-Help: <mailto:linux-cifs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-cifs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb2_writev_callback() marks a write for retry whenever the server fails
it with a replayable status, ignoring smb2_should_replay() and so the
hard and retrans mount options.  The latter is only used to decide on a
backoff, so on a soft mount with no retrans, a server that keeps failing
a write with e.g. STATUS_INSUFFICIENT_RESOURCES gets it resent forever,
thousands of times per second, hanging anything waiting on its
writeback:

  smb3_write_err: R=005c359e[2] ... offset=0x27000 len=0xfdf0 rc=-11
  (569410 times in 255 seconds, same subrequest, no growing delay)

Only retry such writes when cifs_io_should_replay() allows it, as already
done for send errors in smb2_async_writev(), otherwise let them fail.
Writeback thus keeps retrying them with backoff, within its retry
window.  Base the decision on the result of this attempt rather than on
wdata->result, which is never reset on success and may hold the error of
a previous attempt.

Writes cut short by a reconnect get retried regardless too.  Have
writeback ones go through cifs_io_should_replay() as well, so that they
back off and soft mounts give up on them after the retry window, as on
other replayable errors.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ecc127d9f0af..c7b4ea287cb7 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5069,10 +5069,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		credits.instance = server->reconnect_instance;
 		result = smb2_check_receive(mid, server, 0);
 		if (result != 0) {
-			if (is_replayable_error(result)) {
-				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-				__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-			} else {
+			if (!is_replayable_error(result)) {
 				wdata->subreq.error = result;
 				trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_bad);
 			}
@@ -5101,12 +5098,14 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		if (wdata->rreq->origin != NETFS_WRITEBACK)
+			__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RETRY_NEEDED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		if (wdata->rreq->origin != NETFS_WRITEBACK)
+			__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -5160,9 +5159,14 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	wdata->credits.value = 0;
 
 	/* see if we need to retry */
-	if (is_replayable_error(wdata->result) &&
-	    cifs_io_should_replay(wdata))
+	if (is_replayable_error(result) && cifs_io_should_replay(wdata)) {
 		wdata->replay = true;
+		if (!__test_and_set_bit(NETFS_SREQ_NEED_RETRY,
+					&wdata->subreq.flags)) {
+			trace_netfs_sreq(&wdata->subreq,
+					 netfs_sreq_trace_io_retry_needed);
+		}
+	}
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
 	release_mid(server, mid);
-- 
2.56.0

