Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10850330305
	for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699113; cv=none; b=a/F/J8on+1pxM+0s8v7NUyp3gSY/fC1hPn2tu6vbnaXaCXPEU/qXSEHtof444YpXgkYgyfhpOxIlhNz4rgC+/1PjiR7Kyu0iwrM2JdnHuBc58NbX57o+zksOq7Pe9R8KiDOcpgYoQ/eVxWkVhJ6vlnOxCsctOKQX8hoGdJkQi7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699113; c=relaxed/simple;
	bh=fbaA+CF76pa0tdCSSLQ1fpW69I3/dJxzpN9EdEk9EKc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=XooP+V9BF9Q87Gw9qP1/D9gx9s7miCbKrqu/nVJ1cHXBK9emHaywI/6/AYimTo8OS/vF4Iz1RHRW2zsLtyWgqP3Rw9DN/cGVDo+T5b2RlewgVsMoMMtgGAjZwH72r7r1CkhV1WPXJ+TkN2ZD4mX90rUUXlYfC5AdAAIT7WiwU5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D1D3ux0V; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1D3ux0V"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35fc2b18363so3613795a91.0
        for <linux-cifs@vger.kernel.org>; Mon, 20 Apr 2026 08:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776699111; x=1777303911; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TSTGycz2fpyX3ZiwKxX7KwYNacOqh5mj8y3fnHvG8kk=;
        b=D1D3ux0VDMTUUdMOUSQMpDC2txFVRNKgcn8LyPhLAoCqiSQg3C8EDm3VkJq5pTH3e3
         uEmFZHvuPDyVijEPTD2r+i/xuyGLctlm1ymBfKEynx0YMNx5RHw2XQ9g7EI4aJidFT9w
         laqC6gb4g/Jy1Cztz5UW7Lx1t5zemdwV+WxQMLhcOnflwisLKMt6mAshjN/Y6lUU3Gw2
         x/1HGR2vTYV6YTv2FM4w3pPdp/NNWflDDUmUnre9dEatujmWNIxAw+4Hg/dM5KQ4gtiV
         VZay9xG7a7RDoQKqDFiFSyWuEGMlHDK4PqCt0r7kmEBlCvbhD3ZtU6UwgXD9UAmvw8ri
         sevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776699111; x=1777303911;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TSTGycz2fpyX3ZiwKxX7KwYNacOqh5mj8y3fnHvG8kk=;
        b=W76cUYVSDjzddVvJhMEP5Zp6wBav/a04tl3KthOt1/4mbRWgIWrOOjefTZpj8I3GBh
         bH6M0iKssf0RVY7gZ4F3+KVBXo3qbqRaAqQy3LeCGh6zrHd8ondRqAqXJ8Lal3nf1hdY
         PPJwZnRiQZqg/st1JTr+Pl2zsvcA21yjh0AKy2hNgu7RqoJJAgb3hWSqJfObAb1OIiEw
         /YlfBSwJlFzhM3mRAAnYZmZ6f14kkJUO+wRRkp534G8Cee2mua8Wfftddy36Hawnsdl/
         +4S0dYNhB515w31cP7mncq5T+rSEIL5sJQILkbkYzLPC8W7uInIrG1kmCJpsqb2MrHVV
         hkDg==
X-Gm-Message-State: AOJu0Yxvyx+UinfBOXaIED1y3tUg06Ok+pYbkunQgp/rBXGgX2+8xB0b
	YZna6TDSbetCq9zgIU8CoNJP/y4LBLkT4RhtITbkaEV3Eu7vDeRA/oZQ
X-Gm-Gg: AeBDiesBt8kbZYyGQxuf7qjcZ0Cwp+FC+xa5ZZD7m1OMVr43RMB494YN5cUXTfIeFVI
	OnHBH65nZ7QkO701X5OzhnSR/vfBVKVhJGslTfWUXUr1TrVndjVMdp/f7wts04O7v7LklrF9wOu
	LPFKCVrUPWEQydFJbAzACBw5ubbDqSuStoJAfEFsi2Q1Zb6Uf5UuRjuvGu+YfVUYNuWMof8E+oM
	wUxbUuf7IVGJZnrYacymEYK7u/AOzcVB6crWCEhf7QEwEY9ilPOo9m3wvzmJaExERMtn3QxoKhV
	+Nf9EuCqPAszITqn2ME2uYLsfPEsNypA/WjfIQLBfnu8/QB7TLONAiwzRRiPS4W0vjvK2/tYjZi
	6rE6O+52JToS+c/zT8FNCkf/PADIjsY7i7LVfw1zGeh3I37/ou8AWbYiuY/rCV+LwrgymOTendA
	jT7mpvE9XqnQ8aOn08yLJvI3sHxYsPkzW9g4XKinV6mhEHw7lnlxKILA==
X-Received: by 2002:a17:90b:2d8c:b0:35b:93d8:6aaa with SMTP id 98e67ed59e1d1-3614048b3f5mr13813502a91.19.1776699111313;
        Mon, 20 Apr 2026 08:31:51 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5fab32cfasm137381655ad.69.2026.04.20.08.31.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 08:31:50 -0700 (PDT)
Date: Tue, 21 Apr 2026 00:31:47 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: linkinjeon@kernel.org, smfrench@gmail.com, senozhatsky@chromium.org,
	tom@talpey.com
Cc: linux-cifs@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] ksmbd: scope conn->binding slowpath to bound sessions only
Message-ID: <aeZG4xhoMhYFSsIy@v4bel>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When the binding SESSION_SETUP sets conn->binding = true, the flag stays
set after the call so that the global session lookup in
ksmbd_session_lookup_all() can find the session, which was not added to
conn->sessions. Because the flag is connection-wide, the global lookup
path will also resolve any other session by id if asked.

Tighten the global lookup so that the returned session must have this
connection registered in its channel xarray (sess->ksmbd_chann_list).
The channel entry is installed by the existing binding_session path in
ntlm_authenticate()/krb5_authenticate() when a SESSION_SETUP completes
successfully, so this condition is a strict equivalent of "this
connection has been accepted as a channel of this session". Connections
that have not bound to a given session cannot reach it via the global
table.

The existing conn->binding gate for entering the slowpath is preserved
so that non-binding connections keep the fast-path-only behavior, and
the session->state check is unchanged.

Fixes: f5a544e3bab7 ("ksmbd: add support for SMB3 multichannel")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 fs/smb/server/mgmt/user_session.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/smb/server/mgmt/user_session.c b/fs/smb/server/mgmt/user_session.c
index a86589408835..ab8852da76f0 100644
--- a/fs/smb/server/mgmt/user_session.c
+++ b/fs/smb/server/mgmt/user_session.c
@@ -547,8 +547,13 @@ struct ksmbd_session *ksmbd_session_lookup_all(struct ksmbd_conn *conn,
 	struct ksmbd_session *sess;
 
 	sess = ksmbd_session_lookup(conn, id);
-	if (!sess && conn->binding)
+	if (!sess && conn->binding) {
 		sess = ksmbd_session_lookup_slowpath(id);
+		if (sess && !xa_load(&sess->ksmbd_chann_list, (long)conn)) {
+			ksmbd_user_session_put(sess);
+			sess = NULL;
+		}
+	}
 	if (sess && sess->state != SMB2_SESSION_VALID) {
 		ksmbd_user_session_put(sess);
 		sess = NULL;
-- 
2.43.0

