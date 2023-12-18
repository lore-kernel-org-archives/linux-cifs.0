Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33F391D14B;
	Mon, 18 Dec 2023 14:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LwFRSGaJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70154C433C7;
	Mon, 18 Dec 2023 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908916;
	bh=FQ2RkWmJCeB3Aw4Z598opp5zTQYzBN+mvOKSACbkozA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LwFRSGaJzB7pp5Q48zQpa4JNKW1RoASl6ckOe1oV3Okc68GcmEIFRxnzZCdFcF0E2
	 XGy7NEP7R3a9Jo42/mCJbFbyTd2We1/Qu67/pWSe2yLd20kWyx+3tMZK116DUVKtV+
	 RcuTH72iEiw/Q+veZZWpD72F/jxqYy705ZO19Ftk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Steve French <sfrench@samba.org>,
	Hyunchul Lee <hyc.lee@gmail.com>,
	linux-cifs@vger.kernel.org
Subject: [PATCH 5.15 80/83] ksmbd: Mark as BROKEN in the 5.15.y kernel
Date: Mon, 18 Dec 2023 14:52:41 +0100
Message-ID: <20231218135053.258325456@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
References: <20231218135049.738602288@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------


Due to many known bugfixes not being backported properly to the 5.15.y
kernel tree, the ksmbd code in this branch is just not safe to be used
at this point in time at all.  So mark it as BROKEN so it will not be
used.

This can be changed in the future if all needed backports are made by
anyone who cares about this code in this stable kernel branch.

Cc: Namjae Jeon <linkinjeon@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steve French <sfrench@samba.org>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: linux-cifs@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ksmbd/Kconfig
+++ b/fs/ksmbd/Kconfig
@@ -3,6 +3,7 @@ config SMB_SERVER
 	depends on INET
 	depends on MULTIUSER
 	depends on FILE_LOCKING
+	depends on BROKEN
 	select NLS
 	select NLS_UTF8
 	select CRYPTO


