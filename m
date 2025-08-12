Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B092FFDC1;
	Tue, 12 Aug 2025 18:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025169; cv=none; b=PB+jKDlRzsAH1cKr9o2E6wLlt1Q5H7WIZNiGhhKS6rKo0lfzQzmu8MwocM2atM38b733cG0LjNDvF1VH9Utq10Tba8G+IQV1cBqXwAsXemZH4Sgn6dntTBwIZ9GSeXvlYLN1lJkjNJsxoBKcrz03Uo4283rcMbHC1idff8yO4qY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025169; c=relaxed/simple;
	bh=/sVL/4oOkwSsnOXUp6nVESNu1w4q+E/k3x6CACZGLWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JnUpHXVb+yQrtBUzJAIbTjJ524jqG+rlrz7gVtT4e2mzgnwUFmSFHOQz6lM0OrBZUj6yMIjr3awkRtiX97N4TvSH4mAFdWaXzPyTQAnu2yzXmOPrkYuZlCwYaa5Q0SZQ9FxJoyNFI9TLuX3R0XtbfJJ6/29nEpUJdxRi0cVZlGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YgMV0F/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YgMV0F/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA30C4CEF6;
	Tue, 12 Aug 2025 18:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025169;
	bh=/sVL/4oOkwSsnOXUp6nVESNu1w4q+E/k3x6CACZGLWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YgMV0F/L+NMFmwpvq1j1mIyU00TNtzvEJ8YspfR4R0wdOioxSgsliDBTynkD3cuNA
	 0wPaEhNO37Hzu7sgB8Z6dU4n5fym2KYYUBcNGIeHWCK22z1f0MCd9khUlhnogBC3Jg
	 TE5+HNQ91i8a+HERn0WeHIEvdvxVdzyjbldi6K0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-cifs@vger.kernel.org,
	Ralph Boehme <slow@samba.org>,
	David Howells <dhowells@redhat.com>,
	Matthew Richardson <m.richardson@ed.ac.uk>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.16 589/627] smb: client: default to nonativesocket under POSIX mounts
Date: Tue, 12 Aug 2025 19:34:44 +0200
Message-ID: <20250812173454.278647546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paulo Alcantara <pc@manguebit.org>

commit 6b445309eec2bc0594f3e24c7777aeef891d386e upstream.

SMB3.1.1 POSIX mounts require sockets to be created with NFS reparse
points.

Cc: linux-cifs@vger.kernel.org
Cc: Ralph Boehme <slow@samba.org>
Cc: David Howells <dhowells@redhat.com>
Cc: <stable@vger.kernel.org>
Reported-by: Matthew Richardson <m.richardson@ed.ac.uk>
Closes: https://marc.info/?i=1124e7cd-6a46-40a6-9f44-b7664a66654b@ed.ac.uk
Signed-off-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/fs_context.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/smb/client/fs_context.c
+++ b/fs/smb/client/fs_context.c
@@ -1674,6 +1674,7 @@ static int smb3_fs_context_parse_param(s
 				pr_warn_once("conflicting posix mount options specified\n");
 			ctx->linux_ext = 1;
 			ctx->no_linux_ext = 0;
+			ctx->nonativesocket = 1; /* POSIX mounts use NFS style reparse points */
 		}
 		break;
 	case Opt_nocase:


