Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90B0141220
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 23:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FpmF0Ht5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06147C433C8
	for <linux-cifs@vger.kernel.org>; Tue,  5 Dec 2023 23:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701819971;
	bh=azp99BqdCzvYuD7/6MEXJLghkJLXNEE5WlfaDru3ITc=;
	h=From:Date:Subject:To:Cc:From;
	b=FpmF0Ht5QiMzNMk3BT+ifISq29/R/ChkLocWJ+OXGwe3BrLFgp/joyGIrR2naRlz2
	 L+yjLs+E/TX9weLSwQcsv1U43pcFJSHrQMhGc9ltTXDIoVclH4TnRHrGiqjNiYyL+G
	 8EtvZCRQ8Kf7vmzZ1rLAxAPXuzuhYRbpqYW9AI2yaCErcqn55lBDYAFdOXNb9FAChZ
	 Fl65Mi1XV5EBczjtMR6/IQcSOK+uGd8jsDw1xHH5llyXlOC5lbksJqMcaIWO4A6eyZ
	 VwlT2Jjm+3LFF7s+qz0dir3j/GYFKXh53sRAcZOr2AkB/ZsglNOIFNcs/UBz7RPpBZ
	 736RzREGLIDNQ==
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-1f5bd86ceb3so3573233fac.2
        for <linux-cifs@vger.kernel.org>; Tue, 05 Dec 2023 15:46:11 -0800 (PST)
X-Gm-Message-State: AOJu0YyMNAqV69avjsPcFuOSQ1c+lmsRQHHeog+d62Ntz17bauHK4tCE
	tjd23wG5BkWZ7TWzfcD83Gb/ygf/Bv1zZwUB4Z4=
X-Google-Smtp-Source: AGHT+IHIHqGhy5MlMpQHuIRTX5tVH9LFd01w2SmIN+UB2sRPePiKu4q9oHI1QtV2JVbYs4pA6BeiyE5s3YQX8w/uJsA=
X-Received: by 2002:a05:6871:459a:b0:1fa:25de:2f6b with SMTP id
 nl26-20020a056871459a00b001fa25de2f6bmr7282989oab.23.1701819968740; Tue, 05
 Dec 2023 15:46:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Received: by 2002:ac9:5a85:0:b0:507:5de0:116e with HTTP; Tue, 5 Dec 2023
 15:46:07 -0800 (PST)
From: Namjae Jeon <linkinjeon@kernel.org>
Date: Wed, 6 Dec 2023 08:46:07 +0900
X-Gmail-Original-Message-ID: <CAKYAXd_2diW78c1kCehQ3suGyOC6Zj_3fn=A=_GzFAbL8D4nQw@mail.gmail.com>
Message-ID: <CAKYAXd_2diW78c1kCehQ3suGyOC6Zj_3fn=A=_GzFAbL8D4nQw@mail.gmail.com>
Subject: ksmbd: fix wrong name of SMB2_CREATE_ALLOCATION_SIZE
To: CIFS <linux-cifs@vger.kernel.org>
Cc: Steve French <smfrench@gmail.com>, Tom Talpey <tom@talpey.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, atheik <atteh.mailbox@gmail.com>
Content-Type: text/plain; charset="UTF-8"

MS confirm that "AISi" name of SMB2_CREATE_ALLOCATION_SIZE in MS-SMB2
specification is a typo. cifs/ksmbd have been using this wrong name from
MS-SMB2. It should be "AlSi". Also It will cause problem when running
smb2.create.open test in smbtorture against ksmbd.

Cc: stable@vger.kernel.org
Fixes: 12197a7fdda9 ("Clarify SMB2/SMB3 create context and add missing ones")
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
---
 fs/smb/common/smb2pdu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/smb/common/smb2pdu.h b/fs/smb/common/smb2pdu.h
index e373018259e5..5a721c952c2f 100644
--- a/fs/smb/common/smb2pdu.h
+++ b/fs/smb/common/smb2pdu.h
@@ -1142,7 +1142,7 @@ struct smb2_server_client_notification {
 #define SMB2_CREATE_SD_BUFFER			"SecD" /* security descriptor */
 #define SMB2_CREATE_DURABLE_HANDLE_REQUEST	"DHnQ"
 #define SMB2_CREATE_DURABLE_HANDLE_RECONNECT	"DHnC"
-#define SMB2_CREATE_ALLOCATION_SIZE		"AISi"
+#define SMB2_CREATE_ALLOCATION_SIZE		"AlSi"
 #define SMB2_CREATE_QUERY_MAXIMAL_ACCESS_REQUEST "MxAc"
 #define SMB2_CREATE_TIMEWARP_REQUEST		"TWrp"
 #define SMB2_CREATE_QUERY_ON_DISK_ID		"QFid"
-- 
2.34.1
