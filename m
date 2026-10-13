Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277DC4F3937;
	Tue, 13 Oct 2026 12:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895593; cv=none; b=MR2u6GJTqohpvC2z2vbE2nyaFs9xmWRG3XbrpBsOU+XocE3grgGkF3oe67im/wH1jYjP9TT3bGZOb1ifEefIV0bIojoKjd9mMhD6aTEgsu+DDTpJnNJVgSIi+r/Jf7wMgJPUNwrABb0Xsuz7YnwUJnzcYMj8mgkjgzgEaSTwK74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895593; c=relaxed/simple;
	bh=jVht4KgzVAFV+gl14qMQrFWaAgU4Fcpsmt5nDjpCTXk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgurk1owyQX5sJYjjM5m4dnyKTM4rswrOsbV3hKnB6b8gowvKOXhSp4C/8WirRsCdI32BewTuCKihVfEFPJV/eNd+Lyl/OIR0dBNx/4FhINgZFFG6y+qbZ6ZQeC5dtd9f/AHNbCHMoujuoiASaA8xON4eeZzAdYIjd4lCIcQDcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ng9tFqn3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ng9tFqn3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8643A1F000FF;
	Tue, 13 Oct 2026 12:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895591;
	bh=Adpi6jKuDnV0r2enq+l26CxOX1Py0fbcVPZtIZ697og=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ng9tFqn3WXVtJiOwdcdKkuIO2sgV9s6/hLjvPsrzyAz7fNnkjPBhLpeteyARklyTA
	 TX56Ks/XqYzPrRDTq0yIsPZGR7SHTXkrYTaVhayQNNKGd9qQyI0hegy16GDReleJzX
	 dRMojqd/1z+kAzGB+HyvhcWR3ph6jmZx5h9XiBOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	"Paulo Alcantara (Red Hat)" <pc@manguebit.org>,
	Shyam Prasad N <sprasad@microsoft.com>,
	linux-cifs@vger.kernel.org,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Steve French <stfrench@microsoft.com>,
	Mikhail Mirkin <mmirkin@nppct.ru>
Subject: [PATCH 6.12 272/497] cifs: Fix handling of a beyond-EOF DIO/unbuffered read over SMB1
Date: Tue, 13 Oct 2026 13:37:19 +0200
Message-ID: <20261013112914.348170131@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

commit 9d85ac939d52e93d80efb01a299c6f0bedb30487 upstream.

If a DIO read or an unbuffered read request extends beyond the EOF, the
server will return a short read and a status code indicating that EOF was
hit, which gets translated to -ENODATA.  Note that the client does not cap
the request at i_size, but asks for the amount requested in case there's a
race on the server with a third party.

Now, on the client side, the request will get split into multiple
subrequests if rsize is smaller than the full request size.  A subrequest
that starts before or at the EOF and returns short data up to the EOF will
be correctly handled, with the NETFS_SREQ_HIT_EOF flag being set,
indicating to netfslib that we can't read more.

If a subrequest, however, starts after the EOF and not at it, HIT_EOF will
not be flagged, its error will be set to -ENODATA and it will be abandoned.
This will cause the request as a whole to fail with -ENODATA.

Fix this by setting NETFS_SREQ_HIT_EOF on any subrequest that lies beyond
the EOF marker.

This can be reproduced by mounting with "cache=none,sign,vers=1.0" and
doing a read of a file that's significantly bigger than the size of the
file (e.g. attempting to read 64KiB from a 16KiB file).

Fixes: a68c74865f51 ("cifs: Fix SMB1 readv/writev callback in the same way as SMB2/3")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: Shyam Prasad N <sprasad@microsoft.com>
cc: linux-cifs@vger.kernel.org
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Steve French <stfrench@microsoft.com>
[Mikhail Mirkin: Adopted for 6.12]
Signed-off-by: Mikhail Mirkin <mmirkin@nppct.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/smb/client/cifssmb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/smb/client/cifssmb.c
+++ b/fs/smb/client/cifssmb.c
@@ -1321,7 +1321,7 @@ cifs_readv_callback(struct mid_q_entry *
 	} else {
 		size_t trans = rdata->subreq.transferred + rdata->got_bytes;
 		if (trans < rdata->subreq.len &&
-		    rdata->subreq.start + trans == ictx->remote_i_size) {
+		    rdata->subreq.start + trans >= ictx->remote_i_size) {
 			__set_bit(NETFS_SREQ_HIT_EOF, &rdata->subreq.flags);
 			rdata->result = 0;
 		}


