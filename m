Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D6AE3254AC;
	Mon, 27 Oct 2025 19:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593293; cv=none; b=HNvHrKp/AWh08kjPNQ0FsFlK+smKXe0ZEcYW7VfZlvjTup0HcyeN0B9myJScFtocSTaZszZ1AL7Gr4CacU3yc7xVBqkasMXXmQ1PrRXs9LJtADpv6YhQDAgI31nux3YuRpI5ZcrOGFnf6qh9z/7bbkXScSab9EpJcNAORt/lu4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593293; c=relaxed/simple;
	bh=RgxJnjzVXCTOHbMmwAHi/UV8vMGkgFNC2TdZ/ijPPB0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nNQiDPRFA3zy3O5LjJsZ6zoiYL67AYluVOHslIIukyC59u4HxE11Bn7G8E3PHG8DjsyafOvsMpbur6izqHilI2Qz0Lb3oNNdknXSTHbTQhoP1cgWVjWnJT12H/3pCZWqIgWpKV+mCi0kJA8sPxoABQn/vUtteKf+naH8Y+RVL9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbxUSp7m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbxUSp7m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D37BC4CEF1;
	Mon, 27 Oct 2025 19:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593293;
	bh=RgxJnjzVXCTOHbMmwAHi/UV8vMGkgFNC2TdZ/ijPPB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbxUSp7mCSyRBIQegfiJXrxI+YPPni6gN6KA/F0rLfcGZtGDOLL9zLo6WjZBy7d8I
	 8m9vIdudPX9IJ2Qbk60+SnWtBw2ApZeRanRsphwowcmotd5oabY8ohz4Qvkuv9zWNL
	 U3ScJrpUPQRhd2L/drZugcHxJ0UCSZW2dT22KZK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	linux-cifs@vger.kernel.org,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Pavel Shilovskiy <pshilovskiy@microsoft.com>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 6.17 088/184] cifs: Fix TCP_Server_Info::credits to be signed
Date: Mon, 27 Oct 2025 19:36:10 +0100
Message-ID: <20251027183517.266726161@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 5b2ff4873aeab972f919d5aea11c51393322bf58 upstream.

Fix TCP_Server_Info::credits to be signed, just as echo_credits and
oplock_credits are.  This also fixes what ought to get at least a
compilation warning if not an outright error in *get_credits_field() as a
pointer to the unsigned server->credits field is passed back as a pointer
to a signed int.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cifs@vger.kernel.org
Cc: stable@vger.kernel.org
Acked-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
Acked-by: Pavel Shilovskiy <pshilovskiy@microsoft.com>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifsglob.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifsglob.h
+++ b/fs/smb/client/cifsglob.h
@@ -740,7 +740,7 @@ struct TCP_Server_Info {
 	bool nosharesock;
 	bool tcp_nodelay;
 	bool terminate;
-	unsigned int credits;  /* send no more requests at once */
+	int credits;  /* send no more requests at once */
 	unsigned int max_credits; /* can override large 32000 default at mnt */
 	unsigned int in_flight;  /* number of requests on the wire to server */
 	unsigned int max_in_flight; /* max number of requests that were on wire */


