Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=202.12.124.153
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792992924;
	b=wCM66H/izltuWZ1Ewiq/98ejlv8L0jp+bjUu9wjAz1KFSVakE1l3o08ZxOw9g4IA22tr
	 NEHvA5zhimnnFQ5XUSTLEb5nhK7tlw/C8haTlqO47KD+FVikCEFrUgrTu0hN6anOc1d9b
	 foEyn8BZvGu2RPsqwZNgh+tBWod83HU5/EKWJcp5+zmQp1/zAhp5s0SBiXWDeKO/cCt86
	 cAJ/pLqgyPyXU1AjOKfQ0aW9j2mGQEtP9jjunFthdQeB4gXx53UDInBpTW69kINGKhFED
	 U8GuLYIfB1kb+QlPLX5304R0k8RKQJ2deIukigMhBZvj3q7wf5ZuUP9hi9J/JMyRr0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792992924;
	h=DMARC-Filter:Received:Received:DKIM-Signature:DKIM-Signature:
	 X-DKIM2-Info:DKIM2-Signature:X-DKIM2-Info:Message-Instance:
	 X-ME-Sender:X-ME-Received:X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:
	 Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=N3m1qXbf35TLhQZZPDTO3VEfB4Wj9dUkZOaPiyInhQQ=;
	b=m4D4WU8Sk9RWwUfHb92H8iakTjDEmCCcW6MTzsvR1ypc2YCkmGJpFFUfskunOl6YhVZ6
	 8rcyEH6Psz+4caKdWpP8jN0KbB58fNrEebuBGzFdw6o4V6UKeKUZlhlWNSH2dOeHCqON6
	 Leu/SL7GyqIfPzew5GerWj9LJ65O2I2sLFeFq5kW/qj+RtkE7SSziOavP4SjR329LHOTY
	 +RuuSTDiWwT8/fRT3Ow02JKqHrxRM+/yoTjrHJ9BIOWH+Vpoj9tcePCGggDnKT+zP/I6g
	 TuH+sZXaL4OgAm4mw1sX6k2JcEDLuPek1xgvpz63FALJ0Zz2+QzmPgefGIcxj3H7XMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fastmail.org;
	spf=pass smtp.mailfrom=fastmail.org;
	dkim=pass header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=jsZObGPy;
	dkim=pass header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=L7XGtf9r;
	arc=none smtp.remote-ip=202.12.124.153
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEFE7606A31D
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 05:35:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BEFE7606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fastmail.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fastmail.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fastmail.org header.i=@fastmail.org header.a=rsa-sha256 header.s=fm2 header.b=jsZObGPy;
	dkim=pass (2048-bit key, unprotected) header.d=messagingengine.com header.i=@messagingengine.com header.a=rsa-sha256 header.s=fm2 header.b=L7XGtf9r
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 1C74E7A022D
	for <linux-cifs@vger.kernel.org>; Mon, 26 Oct 2026 01:35:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 26 Oct 2026 01:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.org; h=
	cc:cc:content-transfer-encoding:content-type:date:date:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to; s=fm2; t=1792992922; x=1793079322; bh=N3m1qXbf35TLhQZZPDTO3
	VEfB4Wj9dUkZOaPiyInhQQ=; b=jsZObGPyapFB7lzyBdMnNJT4szSv4P3snA3F9
	sbGKq6Vulna7e8BPQ9O8f2MYMtM3kb0AI9RxTx+ollJv0PtcIqG9xP9EfOCkau2L
	Mp49LU/HaxlT6BJm1IlKjHHHly/K9BGTTneCe/gI9A5PUdz8RwJsTRiUlA1q08La
	L4BMLj9pCiewuZo+ci1CyQwTnMuAQu1m2rZSY7WiyP9dpPd9TWL7/KheUXb/FETZ
	HJiYHKClL0GBO13Ucv1onV6s7SzdCsWkCBRzjT6pj08Y48VUfL2Py1ryu8CYxAQi
	M89qrXQ/yKppQY1P3QJVbV94c3BsClM1F8zx3alYRNobD6rOg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1792992922; x=1793079322; bh=N3m1qXbf35TLhQZZPDTO3VEfB4Wj9dUkZOa
	PiyInhQQ=; b=L7XGtf9rS9rewp84Fp7Nfkzoa9iB0bYBBKbnWUFHJIV4cl1LryZ
	M51V4weixBdcuM/AvFdMeIWUWTKukW5O6NP+oFty50UYURd0Pz9bjw58zOyOyQ7J
	bR1gC2mZLafXMF5mi4fITwf+cQDHzYQgADNyyAF+ye0AreblGBkH3MvC6PYolgJ9
	XQPuWdhKUTtDZ2/WgMEqiuHBpVD8IUDMUrGO/rMHamTN58o5f98tk9KXC/wW0Adv
	zu+dzucklYs1zmj0ZI3tHTQCKT4UASvxE4Y4+9WOf3MF/oIeZTTuPRbutb7ZnnUN
	XFh78B221Co565I8PKd0hiiaTCOEnE6msjw==
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=sign d=fastmail.org a=rsa-sha256;
DKIM2-Signature: i=1; m=1; t=1792992922; d=fastmail.org;
	mf=PGljYkBmYXN0bWFpbC5vcmc+;
	rt=PGxpbnV4LWNpZnNAdmdlci5rZXJuZWwub3JnPg==;
	s=fm2:rsa-sha256:LcmOY8FNj3gFtHx5HuiWWUDI71T3wDyPtoCMegwS/DWWVz0
	Um4Py+2/Ss8dgiMgHyvWVE+ji3ClkzGAGX9QxQX2k9/pH7GYcDv7yq+VjLPnI1Ll
	D9uG1WoPGqk+bAxlpcnyWt7XlhBMB3C3Uh79vlKNfRGzI5Cv7YiQNfVHRVx75Ye+
	vRSj/QqbfXZKtuH1ikzQ3o73HvyvpURNGykydRsXCXfkayg+iXb/66iktB33F4DJ
	EFL8ZRAJUy2GlVjKNlogauQzW6YomxaGTalLhp/GRG0emohFnIYdo8Q+9yk73whu
	uFJ0hSwgVEyXs/76woDS5pQ2nz6HZIOoUxwwDlQ==;
X-DKIM2-Info: draft=ietf-dkim-dkim2-spec-07;
	repo=github.com/dkim2wg/interop; date=2026-10-18; sw=lmtpprox;
	action=mi-m=1; hc=9;
	hn=cc,content-transfer-encoding,date,feedback-id,from,
	message-id,mime-version,subject,to;
Message-Instance: m=1; h=sha256:r5zhxWwz8o5R/uSF4DHIbxPUs0Qjtj7+8szg86ege0g=:jAm0V4TlNYR5v65wnj8zyhnOeFl3SLqMnTgCSnEobac=;
X-ME-Sender: <xms:mebeaikpwXXexZAt2hA-Hkv9EYAwrC0Avx2AMKD8EwUUmzczZ-VaXw>
    <xme:mebeaqQSpz-WhCZuXyd19qZ7CRhCUnAN95oHqP-AzrIiRd_McskZ4L5HbeRAk2JzI
    2jQvtyXiqpu-fz3PytuH1QDK823PhNBKJRLHzx0Qu0vGrKiLEis0_7r>
X-ME-Received: <xmr:mebeahVEGWW9V1nhM5uDkUh2Ofvrle-LwyoBGEybQmP3upk6GC7GIg-9Z_iU1VKs>
X-ME-Proxy-Cause: dmFkZTGr4ldGq7W6i39MdyFEJYR8P3hCGcPU+6t6BA2hYKmTRM3+1zFlzyGDWwN5TWFSyj
    gha6BzdjG0a/dnkyYDY6MmpFyQFfC1MTSjLSAu8kRDVB8f8oZFH0v7uDoS2exDpKT/h5iS
    oy2m0jstyY8H8xpoP3mBjkfFQjEPo1Xw+cPSDLhanwpiaBXJ73hLVlLXzoyg1MhJJHhgwt
    MN4W7MX6cf8UDaMGav1ZA1vpb/APk5/f478ACL2UDRKZSi9bHFW252RAOJP3JbPZSuB7Dl
    es7zXcgcqGLPWmgqIBovSj8R7EXdvhsesrPCzrHz+IFSZ/+5NrYpIdSkB6Vr4s6yncP/hn
    7Zm9FnNYmVLqbH6xoaTS86oTs4eeANzTcE7KpGBNSF0uGdqkJXI7PqWihC10KXViB12Uht
    cVrZrB5Q2VIBcHi8xAAxaJy1KGRdWDK+GTvysmmvHIIW23fKWqTdUlze9oVljhSc4tEZWP
    LjvcQgcvAqDMkrnWQzd2tskC3aN30OJi0b//vLqGC4Pvs6zXCgbRHJU1MbF6GNSJKkScVF
    cFsyML7JlL+HJu2vClPHrFWXzCozwR2ICsITQRqTZQA4Xv+3pajzJEA61W5Pg1ExQNSgyP
    CItYQmIgSJ36QC1yvh8ZoRRCBXx7gal6uo4IiCzceRd/YOd5UZ2UAMiA9Dpw
X-ME-Proxy: <xmx:mebeauLBFDCtoFnb0hr7JB6VEmf1S6TuusxveiG_bYClUggS1cuwLQ>
    <xmx:mebeah3SBUuHCPG8TaD5ipEvE97XKvEulCm5mb0S4JvG85gWb3wrvA>
    <xmx:mebearKFcTWlw-UV_urKOcbzIauFFQnnRUKZ6Fod9SOW75QoIXcn0Q>
    <xmx:mebeasiwqbcR0Kbt3uC2HtEjv4Tz2yV6o5HS7AIN7TfZMvxIHiaxUg>
    <xmx:mubeatNes9THuGv5GC3olRpfRNjg26HZoQ2yu1Zb6MwZ5K7gazUfN-eL>
Feedback-ID: ib53e4b78:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 26 Oct 2026 01:35:20 -0400 (EDT)
From: Ian Bridges <icb@fastmail.org>
To: Namjae Jeon <linkinjeon@kernel.org>
Cc: Steve French <stfrench@microsoft.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Tom Talpey <tom@talpey.com>,
	ChenXiaoSong <chenxiaosong@chenxiaosong.com>,
	linux-cifs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ian Bridges <icb@fastmail.org>,
	stable@vger.kernel.org
Subject: [PATCH] ksmbd: fix app-instance non-durable supersede session UAF
Date: Mon, 26 Oct 2026 00:34:22 -0500
Message-ID: <20261026053422.61138-1-icb@fastmail.org>
X-Mailer: git-send-email 2.47.3
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

ksmbd_close_fd_app_instance_id() supersedes a prior open that has the
same AppInstanceId. It reaches that open's session through opinfo->sess.
This pointer is not refcounted.

Session teardown detaches durable handles before it frees the session.
It does not detach a non-durable open. That open still points at the
session through opinfo->sess after the session is freed. Another session
can supersede the open at the same time. The supersede then takes a
write lock through the stale pointer, in the freed session's file table.

  BUG: KASAN: slab-use-after-free in _raw_write_lock+0x71/0xd0
  Call Trace:
   _raw_write_lock+0x71/0xd0
   ksmbd_close_fd_app_instance_id+0xd9/0x670 [ksmbd]
   smb2_open+0x3e10/0xd910 [ksmbd]
  Freed by task 212:
   ksmbd_session_destroy+0x38d/0x480 [ksmbd]

Fix this by looking the session up by opinfo->session_id. The lookup
returns a reference, as smb2_break_collect_channels() does. Recheck that
opinfo->sess still points at it before using it.

Do the lookup without m_lock held. destroy_previous_session() takes
m_lock under the session table lock, and taking them in the other order
here would deadlock.

Fixes: 16c30649709d ("ksmbd: handle durable v2 app instance id")
Cc: stable@vger.kernel.org # e0386cd6498b: ksmbd: validate AppInstanceId takeover target
Cc: stable@vger.kernel.org
Signed-off-by: Ian Bridges <icb@fastmail.org>
---

Notes:
    The bug needs an authenticated client with oplocks enabled, which is
    the default. Two sessions with different ClientGUIDs open the same
    file with the same AppInstanceId. The first session is then torn down
    by LOGOFF or a disconnect while the second session's CREATE is
    superseding it.
    
    A reproducer is available on request.

    The durable variant of this UAF was fixed by f363a0fb134a ("ksmbd: fix
    app-instance durable supersede session UAF"). This is the non-durable
    sibling. It predates that fix, so the Fixes tag points at the original
    app-instance commit 16c30649709d.

    An alternative fix also works. It takes a session reference in the
    oplock_info. That changes session lifetime across durable reconnect
    and touches more call sites.

    This fix was developed with LLM assistance (code review and KASAN
    reproduction).

    Tested on ksmbd-for-next ed0063dd with only this patch applied, under
    KASAN. The reproducer no longer triggers the report. The superseding
    CREATE still succeeds. The race window was widened with a temporary
    msleep() in smb2_handle_app_instance_id() to reproduce reliably. That
    instrumentation is not part of this patch.

 fs/smb/server/vfs_cache.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/fs/smb/server/vfs_cache.c b/fs/smb/server/vfs_cache.c
index 7a0f13277..28170c30f 100644
--- a/fs/smb/server/vfs_cache.c
+++ b/fs/smb/server/vfs_cache.c
@@ -1262,7 +1262,9 @@ int ksmbd_close_fd_app_instance_id(struct ksmbd_work *work,
 				 struct ksmbd_file *fp, bool *closed)
 {
 	struct ksmbd_file_table *ft;
+	struct ksmbd_session *sess;
 	struct oplock_info *opinfo;
+	u64 session_id;
 	int n_to_drop = 0;
 
 	*closed = false;
@@ -1275,10 +1277,35 @@ int ksmbd_close_fd_app_instance_id(struct ksmbd_work *work,
 		up_read(&fp->f_ci->m_lock);
 		goto out;
 	}
+	/*
+	 * opinfo->sess is not refcounted, and m_lock does not keep it alive.
+	 * The owner can be torn down while we hold only a reference to fp.
+	 * Look the owner up by id to take a real reference instead.
+	 */
+	session_id = opinfo->session_id;
+	up_read(&fp->f_ci->m_lock);
 
-	ft = &opinfo->sess->file_table;
+	/* destroy_previous_session() takes m_lock under sessions_table_lock. */
+	sess = ksmbd_session_lookup_slowpath(session_id);
+	if (!sess)
+		goto out;
+
+	down_read(&fp->f_ci->m_lock);
+	if (opinfo->sess != sess) {
+		up_read(&fp->f_ci->m_lock);
+		ksmbd_user_session_put(sess);
+		goto out;
+	}
+	ft = &sess->file_table;
 	write_lock(&ft->lock);
-	if (fp->f_state == FP_INITED && has_file_id(fp->volatile_id) &&
+	/*
+	 * The table may already be detached by destroy_previous_session().
+	 * A new session could also reuse the old id and address and pass the
+	 * check above. Only remove fp if this table still publishes it.
+	 */
+	if (ft->idr && fp->f_state == FP_INITED &&
+	    has_file_id(fp->volatile_id) &&
+	    idr_find(ft->idr, fp->volatile_id) == fp &&
 	    ksmbd_app_instance_id_matches(work, fp)) {
 		idr_remove(ft->idr, fp->volatile_id);
 		fp->volatile_id = KSMBD_NO_FID;
@@ -1286,6 +1313,7 @@ int ksmbd_close_fd_app_instance_id(struct ksmbd_work *work,
 	}
 	write_unlock(&ft->lock);
 	up_read(&fp->f_ci->m_lock);
+	ksmbd_user_session_put(sess);
 	opinfo_put(opinfo);
 	opinfo = NULL;
 

base-commit: ed0063dd214dce027717f64817c594cc1b2e1d41
-- 
2.47.3

