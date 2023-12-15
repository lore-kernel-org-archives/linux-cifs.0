Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ADEE3FB1A
	for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 17:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNAm+B1H"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5c65ca2e1eeso439892a12.2
        for <linux-cifs@vger.kernel.org>; Fri, 15 Dec 2023 09:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1702660626; x=1703265426; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YNohwMkxQEk//lSnhopBEMjKiAOO70+tuLCR9Gvi02g=;
        b=TNAm+B1HQEdBcarIY4rzUphY7K7vxx7VuHO5n6lssw93afSmw36mI3NLfnJUGlRD2l
         gbRo/kLmBwtvLOzzS2X68/kR8xymZnanzbXiji/h0aWq7VneIGhPKj2WJJT+nMw+2b5E
         81Efi5kF27x2nd/WDJCipYr50G2HLUeb0joILi2vCkmj+gSra/Vta/DDbcNMW7pDCT/y
         fzgmPWWce8+9oUOukSmBziVzUgsaavEp8aYpbx+aeGsOsQnqsBDe1nbB13ZkQYAGeWNm
         yzQSwUGebtoYaJ3S7TVPckdlT1cOY5fvkGlEHxCRtcOXe0eBCvxl16LrS2bzHcA1joRa
         2wRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702660626; x=1703265426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YNohwMkxQEk//lSnhopBEMjKiAOO70+tuLCR9Gvi02g=;
        b=nr7NC9shUqsIfEUrS+xM2WqOtj1THrXR9EKfQl4zqg8HvVxnyqdJPYg/m/UVV7M5aN
         wgGiiXJee9b4HsoJlWjJ6ivZu2b3iG81fcfAphBC3JaG6PW4dnKlfXFdDIWC2bBGUMSx
         NNrQaMOI8B12jRLtscCkYtvCA9jGb6th3b3hP8oZ+Z4VbDX7Oc9Xxw24VcZRZ6usP5RM
         Y9eLKG1HFWz6yFaq2d2aW9k7e1E0EBiHmB8loXOD3gNfMe8PTz5GMexubGRzQPSfFQ30
         k/Sud729nX8/A29xeMNyqFtEGERdINyyWSmwc1dPe0BfBZDcKXBOq4jcbopUbdZUJmjQ
         cF0g==
X-Gm-Message-State: AOJu0Yxo+3+CwFt09M0HJ0RZ8Top1lVz3TQMOC78OYqWRbAFoWeKMM4v
	ENHwIXahDJ0qEcgEPQmG44c=
X-Google-Smtp-Source: AGHT+IGAXmBgbN/VhtfJALONtl1bYXLagtqFbUAoYbcEZINT2Urq7ZLZL+VYqG1+IltkHju4wqU5sg==
X-Received: by 2002:a05:6a20:734f:b0:18b:5a8a:4333 with SMTP id v15-20020a056a20734f00b0018b5a8a4333mr5552548pzc.19.1702660626392;
        Fri, 15 Dec 2023 09:17:06 -0800 (PST)
Received: from lindev-local-latest.corp.microsoft.com ([2404:f801:8028:3:7e0c:5dff:fea8:2c14])
        by smtp.gmail.com with ESMTPSA id g13-20020aa79dcd000000b006d26eed29a8sm2125970pfq.95.2023.12.15.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Dec 2023 09:17:05 -0800 (PST)
From: nspmangalore@gmail.com
X-Google-Original-From: sprasad@microsoft.com
To: pc@manguebit.com,
	smfrench@gmail.com,
	linux-cifs@vger.kernel.org
Cc: Shyam Prasad N <sprasad@microsoft.com>
Subject: [PATCH 2/2] cifs: do not let cifs_chan_update_iface deallocate channels
Date: Fri, 15 Dec 2023 17:16:56 +0000
Message-Id: <20231215171656.4140-2-sprasad@microsoft.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20231215171656.4140-1-sprasad@microsoft.com>
References: <20231215171656.4140-1-sprasad@microsoft.com>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shyam Prasad N <sprasad@microsoft.com>

cifs_chan_update_iface is meant to check and update the server
interface used for a channel when the existing server interface
is no longer available.

So far, this handler had the code to remove an interface entry
even if a new candidate interface is not available. Allowing
this leads to several corner cases to handle.

This change makes the logic much simpler by not deallocating
the current channel interface entry if a new interface is not
found to replace it with.

Signed-off-by: Shyam Prasad N <sprasad@microsoft.com>
---
 fs/smb/client/sess.c | 50 +++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 31 deletions(-)

diff --git a/fs/smb/client/sess.c b/fs/smb/client/sess.c
index 816e01c5589b..2d3b332a79a1 100644
--- a/fs/smb/client/sess.c
+++ b/fs/smb/client/sess.c
@@ -439,7 +439,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 		cifs_dbg(FYI, "unable to find a suitable iface\n");
 	}
 
-	if (!chan_index && !iface) {
+	if (!iface) {
 		cifs_dbg(FYI, "unable to get the interface matching: %pIS\n",
 			 &ss);
 		spin_unlock(&ses->iface_lock);
@@ -447,7 +447,7 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 	}
 
 	/* now drop the ref to the current iface */
-	if (old_iface && iface) {
+	if (old_iface) {
 		cifs_dbg(FYI, "replacing iface: %pIS with %pIS\n",
 			 &old_iface->sockaddr,
 			 &iface->sockaddr);
@@ -460,44 +460,32 @@ cifs_chan_update_iface(struct cifs_ses *ses, struct TCP_Server_Info *server)
 
 		kref_put(&old_iface->refcount, release_iface);
 	} else if (old_iface) {
-		cifs_dbg(FYI, "releasing ref to iface: %pIS\n",
+		/* if a new candidate is not found, keep things as is */
+		cifs_dbg(FYI, "could not replace iface: %pIS\n",
 			 &old_iface->sockaddr);
-
-		old_iface->num_channels--;
-		if (old_iface->weight_fulfilled)
-			old_iface->weight_fulfilled--;
-
-		kref_put(&old_iface->refcount, release_iface);
 	} else if (!chan_index) {
 		/* special case: update interface for primary channel */
-		cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
-			 &iface->sockaddr);
-		iface->num_channels++;
-		iface->weight_fulfilled++;
-	} else {
-		WARN_ON(!iface);
-		cifs_dbg(FYI, "adding new iface: %pIS\n", &iface->sockaddr);
+		if (iface) {
+			cifs_dbg(FYI, "referencing primary channel iface: %pIS\n",
+				 &iface->sockaddr);
+			iface->num_channels++;
+			iface->weight_fulfilled++;
+		}
 	}
 	spin_unlock(&ses->iface_lock);
 
-	spin_lock(&ses->chan_lock);
-	chan_index = cifs_ses_get_chan_index(ses, server);
-	if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+	if (iface) {
+		spin_lock(&ses->chan_lock);
+		chan_index = cifs_ses_get_chan_index(ses, server);
+		if (chan_index == CIFS_INVAL_CHAN_INDEX) {
+			spin_unlock(&ses->chan_lock);
+			return 0;
+		}
+
+		ses->chans[chan_index].iface = iface;
 		spin_unlock(&ses->chan_lock);
-		return 0;
 	}
 
-	ses->chans[chan_index].iface = iface;
-
-	/* No iface is found. if secondary chan, drop connection */
-	if (!iface && SERVER_IS_CHAN(server))
-		ses->chans[chan_index].server = NULL;
-
-	spin_unlock(&ses->chan_lock);
-
-	if (!iface && SERVER_IS_CHAN(server))
-		cifs_put_tcp_session(server, false);
-
 	return rc;
 }
 
-- 
2.34.1

