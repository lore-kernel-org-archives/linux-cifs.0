Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=143.255.12.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794071591;
	b=vEHpk27MOzBhCiIRXAq/Vm4NuzZ2REnNsQtYlUBLIyQRd8ujtBwz1dKNmehr3xqFOrjX
	 PGZYtLTIZiKII9Su3FwsDDWjZiZqshwMrtkr1rRq9x+nftyiEiXWvCXfDY/d7HRvsTMKe
	 eoON7L6WQbMUD+dFWd9AyWQ2B1vaO1P8lsskY8dOsSF/9PeJYjYIHQNi1NA0JomuZxTJr
	 Ja/JV90RS6CdUyxX8UO/hcKMrKEHCjh3UDZe7JdyWkeEjiSt+uCW/0pEsmfq6B0Av02RQ
	 /2SkzJ4dLQDM0Y3fRQkONPSmIe5tZXst3373WLcxw0lWCH9t5qkkMKF51D6aWU5HLZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794071591;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=BrifJQ4gacd4ZwkZnHpS1JoeGEyUGf/5MClugtFcKkk=;
	b=Pmx7pS0lgMbB5qXzmWlUCoNI7KiHCO+2pUps2x5uv3EUU9p3Hcd/Qv6anzBVch5FYNi9
	 M2PBmbVC4MvBM1wy5hqgdu06o9eoLAd49DIpewZONYcJxi8OtuiAPyZ+XQVG80mcOpgb/
	 IKCMIA9w6kTNobYzkx3wFPLim6aX/9k3KabH2XgQEyAXkhdbcPyfZmzntajX9wjP2eb36
	 ipORjRYiqL9IH7k15x40HZ2WDbjrc/Cov/l2vyhf0J+zbccdreAaDJ3u3pgjF2/DhZ1FP
	 NYtqDwXfX4/ZmdtioC3ttQnE6OiG1W++I2RPDeJF2Lm6gjBtwP4FYoFtEd2GXNO/JWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=manguebit.org;
	spf=pass smtp.mailfrom=manguebit.org;
	dkim=pass header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6UU6T4Bx;
	arc=none smtp.remote-ip=143.255.12.172
Received: from mx1.manguebit.org (mx1.manguebit.org [143.255.12.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF299606A336;
	Sat,  7 Nov 2026 17:13:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CF299606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manguebit.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manguebit.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manguebit.org header.i=@manguebit.org header.a=rsa-sha256 header.s=dkim header.b=6UU6T4Bx
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=manguebit.org; s=dkim; h=Content-Transfer-Encoding:MIME-Version:References:
	In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Content-Type:Reply-To:
	Content-ID:Content-Description;
	bh=BrifJQ4gacd4ZwkZnHpS1JoeGEyUGf/5MClugtFcKkk=; b=6UU6T4BxkJHMDBAm6SMVh+rOr5
	AkmGba0N96rX25Uw1zuPdoJwC/dhUi0hIEGxABTBiLPqFic0XMKNyhqq6rHx4NlgVVq7CK/pmHse+
	wBDcxlp4Ikltevp9RsAjLhNCFcPGjRHumoKrW8dQwgqFLTA09Q6foBdYHUKMdXAR2sAFdAvk3/r+Z
	uLsGbXUpJedyjNf15Oh8dLgPwyRB9Ty/zyUpDDmPQltO9q23ZGdgUovwUvEHDgPxgrG6GvajYiRFG
	bfB2zP+UDNBf3LxrRKU6POnDI1oq0D6xccaaDXzi/fET4OmueUZP42Kj5JHaXljk/1FIFUc7f9Iyk
	BEKn7nCg==;
Received: from pc by mx1.manguebit.org with local (Exim 4.100.1)
	id 1xPjyU-000000017gA-3t5b;
	Sat, 07 Nov 2026 14:13:08 -0300
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
Subject: [PATCH v9 07/19] smb: client: don't retry failed writes forever regardless of mount options
Date: Sat,  7 Nov 2026 14:12:53 -0300
Message-ID: <20261107171305.2847361-8-pc@manguebit.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107171305.2847361-1-pc@manguebit.org>
References: <20261107171305.2847361-1-pc@manguebit.org>
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
other replayable errors.  Other writes cut short keep being retried,
without spending the mount's retries, but as replays, since they may
have reached the server, unless umount -f stopped them, which fails them
with -EIO.

Fixes: 2c1238a7477a ("cifs: make retry logic in read/write path consistent with other paths")
Signed-off-by: Paulo Alcantara <pc@manguebit.org>
Cc: stable@vger.kernel.org
---
 fs/smb/client/smb2pdu.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index ecc127d9f0af..736c5c693c79 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -5056,6 +5056,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	};
 	unsigned int rreq_debug_id = wdata->rreq->debug_id;
 	unsigned int subreq_debug_index = wdata->subreq.debug_index;
+	bool cut_short = false;
 	ssize_t result = 0;
 	size_t written = 0;
 
@@ -5069,10 +5070,7 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
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
@@ -5101,12 +5099,9 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 		break;
 	case MID_REQUEST_SUBMITTED:
 		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_req_submitted);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
-		result = -EAGAIN;
-		break;
+		fallthrough;
 	case MID_RETRY_NEEDED:
-		trace_netfs_sreq(&wdata->subreq, netfs_sreq_trace_io_retry_needed);
-		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+		cut_short = true;
 		result = -EAGAIN;
 		break;
 	case MID_RESPONSE_MALFORMED:
@@ -5160,9 +5155,17 @@ smb2_writev_callback(struct TCP_Server_Info *server, struct mid_q_entry *mid)
 	wdata->credits.value = 0;
 
 	/* see if we need to retry */
-	if (is_replayable_error(wdata->result) &&
-	    cifs_io_should_replay(wdata))
+	if (is_replayable_error(result) &&
+	    ((cut_short && wdata->rreq->origin != NETFS_WRITEBACK &&
+	      !cifs_io_stopped(wdata)) ||
+	     cifs_io_should_replay(wdata))) {
 		wdata->replay = true;
+		trace_netfs_sreq(&wdata->subreq,
+				 netfs_sreq_trace_io_retry_needed);
+		__set_bit(NETFS_SREQ_NEED_RETRY, &wdata->subreq.flags);
+	} else if (cut_short && cifs_io_stopped(wdata)) {
+		result = -EIO;
+	}
 
 	cifs_write_subrequest_terminated(wdata, result ?: written);
 	release_mid(server, mid);
-- 
2.56.0

