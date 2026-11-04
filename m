Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827702;
	b=W6gHoJVOOWhG4r913SfJGWlSEselhkJpEtl0HnNcEj+mEGGTYdccp23GpU/oD1j7V7CN
	 sl1yRzm/bt5IuMiAgo/iH2Hv/QtqFKYpXQwTzYBz28OR0vwhSBEBDNYinK2W4JdNZeTaL
	 4efix0K50sTbNVXyzP1aFoizmLLZ163RmD4q6hGe7nyJ0KbXjL4Yc1zaT4F6fZqwf/2p0
	 M60VkSYCqeNBCwl6Z3FLFnTvRCva0gSWPnbIC1Cwck7CtrVB39UWn6uFB3CaOT+rkOAcO
	 tobG0JqxTVxFgx54Br44qNaYzbwlyk16F6KqZpaJUV1l6DdEO7xuttZOdny5aWAhN+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827702;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=56ajtd/v84dVv+akWEBhVvPYrZBPjRZRUFTb/qpj5cU=;
	b=Y+H9cgv+tjgSCxQ9EXNpO24nfYBdvTzIfwVQi92c/GGrp487NQrILQnj1m3Kn3u58/Uz
	 QjJCmIri95jiL/1fdhw2WsG1E4nBBGKcs4g/9HQmewJwFvQ5tT07X+Mm2QmG9Q8+M/+l7
	 9wTyY/QjPcGaInwcShRsrMlCju81gOfgwE/qugBN8dko/o9uDRa3Hrpcz8m/oLnsf9AJN
	 /qZpBHyJd8Ggw48miNaG3g9pspMXPoIsjmoFZt7si8MSMEK+M70QlI6GKBAPboVDvnKBR
	 /4H1B5xvBh0lsGGZvVxdwhgw4ya6Asal2vBfAH50+905qiY85pmWv9vH37v8/7mZHPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=PDnjGMqd;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D81E606C581;
	Wed,  4 Nov 2026 21:28:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2D81E606C581
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=PDnjGMqd
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=56ajtd/v84dVv+akWEBhVvPYrZBPjRZRUFTb/qpj5cU=; b=PDnjGMqdWnlxMucgyUXPdBfN7T
	wgv16Y3B4erMwFcFqSdWfP/4CroWUztYrkwOWJBeOxuAR3/7hq2SEaYnRlg+Br7W0sdQRZBEiVmxp
	iOObWQZkz7RNLUZ/Y2brdon0Du7yo85y/WRuDOCCVkm4pslivcKJZcoVPumMkso52lx8HaU+srXB5
	TgW+LWJ0uCyJt5yq0/3S0ETv/s7W8PPYkbG76/L20uJAM6aiHVvHJu0YJx6LL40d60epv0B29pLcQ
	CL4I9RMTL6VfRR4ZrcXA1tO2jtb4lIjxAByw1vhpRHaNFK60LgKvRVytbtlqfuDythpR6+uGWX3qT
	n90koe7Q==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xOiWh-00000000rGK-3YKS;
	Wed, 04 Nov 2026 18:28:13 -0300
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
Subject: [PATCH v4 06/17] smb: client: don't retry failed writes forever regardless of mount options
Date: Wed,  4 Nov 2026 18:27:59 -0300
Message-ID: <20261104212810.1935575-7-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104212810.1935575-1-pc@manguebit.org>
References: <20261104212810.1935575-1-pc@manguebit.org>
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

