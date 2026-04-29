Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 381D32FE58C
	for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 20:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777495998; cv=none; b=E24u51ZOuW9UYCVn6ijkDDg6Oeo7cO6GfMRJC5nLr8k8iDd2O1QJpcIcAvq40osADhvufy4EA5AcE8XHy2El0T7+1Ul1JwEWZM8inZ0Ik7RwXU/oMiMCWgk19WLLSo+U4RLJUttFI+rujpYpOeemNEKlhYYrRMhcKGE+z94QOM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777495998; c=relaxed/simple;
	bh=IiFNR2+WijGb9FrHO/PADeJfGkQ9mQYCgDD03ICPANs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G087Q3+0xeczYS4ge218Jk6YlUyoK3inPpFr2rPRe5zZbFXU14a8YivWsOZFs6q3yPld7hRxLakyp4n6fpTcZIqRcLMYJCpgDUKVPpgfX/MYnstp2tJtFy6KegcW79ILL7J8b+QTkjLvTjFF/ZFnu8hopq6sGK3BoiyMLKDsB1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=MpwalMYL; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="MpwalMYL"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4891c00e7aeso1615425e9.2
        for <linux-cifs@vger.kernel.org>; Wed, 29 Apr 2026 13:53:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1777495996; x=1778100796; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJSq4V3powXkVcfGmSruYclyZoV2WmI9BprF8rckwPQ=;
        b=MpwalMYLBrUmf3ZE1NOX3jnoTs022uwN8F9Pbh3QL/srUJ0Bj/QMuV1zK6BmV3visQ
         KgQquQOykRRH82nKGFpttjEbemEkjpFNXPO9TqxEr+kHN04fyuJkNV67l69ZHVjnKF0E
         EV5Xzz+obkPSZd+AF+eOvJfMU+Lk5EULqxIJWpVRftUl05cfWfM4LlZmHVY+0eGpU6H+
         VG6BpUA1iwnsqDjjPpShmAEgNREJPoZd1/11VttZNFO2mC9LPYirJViosVxwCY2SKL0Z
         fxpKD75T+hB4xhe+kr8vM/bs6yxm/PWPqpxUMYTb+oG8U+g0IvWXN6B5B3d82cVzrLFN
         cy1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777495996; x=1778100796;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mJSq4V3powXkVcfGmSruYclyZoV2WmI9BprF8rckwPQ=;
        b=Gr3rtWgtIt6pMfPpLAxOgVqGcE8wIRoCQMwV7sU9ZxvGu422kFYtfmZCf3tlTUznvt
         b6LxszII9hrCxNnxGFnvAjtabFEGgLv/Hndh66L190UUuz/qocBbC96THfEnDDTqxWhJ
         QTfMfNYVP4+/pFWUTvH/6kEEQu9S42emnHAZZjhA6Sa/n/80Ter4RZdRYVklHufUNrm3
         aKfNKXuJEWwy+DYK7ZEXsHml9vALTsYAHkRQ0VmkAEHA3FDOQ8fPDt0ovWrfM9ZkIyTB
         kdZPf27bBmaTZnjw0y8ldeaBRjoWVg2BLvxISbthf/Rbgm+omw6DtnbpS523fYNqD3e4
         YFTg==
X-Forwarded-Encrypted: i=1; AFNElJ8sQr2vN/76cSrxGoQtF6dQdUxA4y88vyiKW3A8OcyAkZc3/994hsXgjbW68GncmFtIGPGb5A5sziPg@vger.kernel.org
X-Gm-Message-State: AOJu0YxBY1DZV68eydPZ6oOMqiVaaBCCsVMyhe4UAFLQ4OvLpErlMxlV
	EDHOrNdFpFf/C/7/zAMdn6juvOrE8Y4jMOhrfp4shvBNE/PhZVLMG/KwBbUZwSjrxUE=
X-Gm-Gg: AeBDievLfbZ8z1gRL0vFyFXyhR+ROihKkHX1PpUfHTt3c3vIHFkD4ItEFcFpUW4UqDO
	i3bHSwomtB3f5MYRv6kwGWH3glzKqJrBlc3ouEclk+dnumPsvvOa8B1FvH+6n8t9uLFUCL6s2rs
	O/fmkTqSUFQ/LI4mgum+h9KxrhXK7ejW3uYy4/OHMyC53BFUGlc4vb0RgrSAm6IdkfKsFM4iEqT
	KxMXsMii+YvhhCLhNjI85nEh87E8OPRoDgDQ4k+3/QszMGbO9D8/B20Esqv8wQETBX2XkaEZHQK
	S+3+ZXE7IP4iLwNnP8bbRfUN7G++MoopwIr3EiSD2RW7C0VIIlfaYPg1snQqAF+DXRzCJ/mM/y6
	QzULQz12rGFU4g6cTb6m2QcVYQdhYWTmAHJUWv8sqU+08Dy0tg7Z4/uIjK58WAcpJk7H61kXoXE
	l0sAyVY+ETOya0E/hmmAWpnRSkf4sg1QGMwD494tYdmr7K
X-Received: by 2002:a05:600c:1d18:b0:488:904b:f31 with SMTP id 5b1f17b1804b1-48a84459207mr2787985e9.22.1777495995617;
        Wed, 29 Apr 2026 13:53:15 -0700 (PDT)
Received: from precision ([2a01:4b00:c007:bb00:be9d:a3c4:18b1:4a25])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12de3269b41sm3925240c88.13.2026.04.29.13.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 13:53:14 -0700 (PDT)
From: Henrique Carvalho <henrique.carvalho@suse.com>
To: sfrench@samba.org
Cc: metze@samba.org,
	pc@manguebit.org,
	ronniesahlberg@gmail.com,
	sprasad@microsoft.com,
	tom@talpey.com,
	bharathsm@microsoft.com,
	ematsumiya@suse.de,
	linux-cifs@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH 3/3] smb: client: make smb3_update_ses_channels() match expected API
Date: Wed, 29 Apr 2026 17:52:36 -0300
Message-ID: <20260429205236.456099-3-henrique.carvalho@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429205236.456099-1-henrique.carvalho@suse.com>
References: <20260429205236.456099-1-henrique.carvalho@suse.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

smb3_update_ses_channels() was introduced with a 0-or-errno API, but
could return a positive channel count when growing channels. Existing
reconnect paths mostly tolerated this, but newer callers can treat it as
failure.

Normalize positive return values from cifs_try_adding_channels() to 0 so
smb3_update_ses_channels() follows the expected API used by its callers.

Fixes: ef529f655a2c ("cifs: client: allow changing multichannel mount options on remount")
Cc: stable@vger.kernel.org
Signed-off-by: Henrique Carvalho <henrique.carvalho@suse.com>
---
 fs/smb/client/smb2pdu.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/smb/client/smb2pdu.c b/fs/smb/client/smb2pdu.c
index cb61051f9af3..9eb7c16407cc 100644
--- a/fs/smb/client/smb2pdu.c
+++ b/fs/smb/client/smb2pdu.c
@@ -236,9 +236,11 @@ int smb3_update_ses_channels(struct cifs_ses *ses, struct TCP_Server_Info *serve
 	if (disable_mchan)
 		rc = cifs_chan_skip_or_disable(ses, server, from_reconnect, disable_mchan);
 	else {
-		if (ses->chan_count < ses->chan_max)
+		if (ses->chan_count < ses->chan_max) {
 			rc = cifs_try_adding_channels(ses);
-		else if (ses->chan_count > ses->chan_max)
+			if (rc > 0)
+				rc = 0;
+		} else if (ses->chan_count > ses->chan_max)
 			rc = cifs_chan_skip_or_disable(ses, server, from_reconnect, disable_mchan);
 	}
 
-- 
2.53.0

