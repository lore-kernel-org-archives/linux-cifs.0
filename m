Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (3072-bit key) header.d=samba.org header.i=@samba.org header.b="mXUBpnum"
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2FFD53
	for <linux-cifs@vger.kernel.org>; Thu,  7 Dec 2023 09:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
	s=42; h=Message-ID:Cc:To:From:Date;
	bh=6Dx/xHDA5bswLH7hOt9ozbRBLobX7v1+DWHkXXnAEGU=; b=mXUBpnumu8oIKipJijbTqMSLG1
	ZfQNW3yQAEwVsb1s6Zv/FEDD5xnKvuqLAKEEbBrICGXxLr1Z0A8kFJJTFWn+aZfFjYjU+H1MLHGVS
	LS1LUggLofb7ADhdbm3xq5xXVS0+fGSJuuErwuS5B21AsImLtxlKOavPNjS9LQ4DYax0MrQK/aJOn
	1WGntH5Y4JKHasXz5Y3cANDUUpQxkkY+kP0MfRpnQ/T5WuXfeOIvTx+CIsDzxo4KQP9eh4U28Z40w
	31Av1CshYvJ8g0onhUczhVxowycjIBoPG/GIX2pCWqXhAVd7M+JRxPrziub+piMNWvFOwJRDEWB2V
	iVddDpsTOdK3xuhJvhHhY7je+62bf/6JTU2gebfuhhmJVkZ/MJj4cmLVJaFBkMU3S9ayM1M/l6ngH
	QRoi8CXw9CzjE5/0iwWDZSlkMYtGrWvRbBRGtVmkEsNZdtsWZUT+MBDqY+PCNUoUN99gte60yWu9b
	g6Oayszt97c53mKHXHkaJoD3;
Received: from [127.0.0.2] (localhost [127.0.0.1])
	by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
	(Exim)
	id 1rBIMI-002QYw-0w;
	Thu, 07 Dec 2023 17:40:24 +0000
Date: Thu, 7 Dec 2023 09:40:18 -0800
From: Jeremy Allison <jra@samba.org>
To: David Howells <dhowells@redhat.com>
Cc: Steve French <smfrench@gmail.com>, Namjae Jeon <linkinjeon@kernel.org>,
	ronniesahlberg@gmail.com, Tom Talpey <tom@talpey.com>,
	Stefan Metzmacher <metze@samba.org>, jlayton@kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org
Subject: Re: Can fallocate() ops be emulated better using SMB request
 compounding?
Message-ID: <ZXIDgvZ8/iBhYXwy@jeremy-HP-Z840-Workstation>
Reply-To: Jeremy Allison <jra@samba.org>
References: <700923.1701964726@warthog.procyon.org.uk>
Precedence: bulk
X-Mailing-List: linux-cifs@vger.kernel.org
List-Id: <linux-cifs.vger.kernel.org>
List-Subscribe: <mailto:linux-cifs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-cifs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <700923.1701964726@warthog.procyon.org.uk>

On Thu, Dec 07, 2023 at 03:58:46PM +0000, David Howells wrote:
>Hi Steve, Namjae, Jeremy,
>
>At the moment certain fallocate() operations aren't very well implemented in
>the cifs filesystem on Linux, either because the protocol doesn't fully
>support them or because the ops being used don't also set the EOF marker at
>the same time and a separate RPC must be made to do that.
>
>For instance:
>
> - FALLOC_FL_ZERO_RANGE does some zeroing and then sets the EOF as two
>   distinctly separate operations.  The code prevents you from doing this op
>   under some circumstances as it doesn't have an oplock and doesn't want to
>   race with a third party (note that smb3_punch_hole() doesn't have this
>   check).
>
> - FALLOC_FL_COLLAPSE_RANGE uses COPYCHUNK to move the file down and then sets
>   the EOF as two separate operations as there is no protocol op for this.
>   However, the copy will likely fail if the ranges overlap and it's
>   non-atomic with respect to a third party.
>
> - FALLOC_FL_INSERT_RANGE has the same issues as FALLOC_FL_COLLAPSE_RANGE.
>
>Question: Would it be possible to do all of these better by using compounding
>with SMB2_FLAGS_RELATED_OPERATIONS?  In particular, if two components of a
>compound are marked related, does the second get skipped if the first fails?

Yes:

https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-smb2/46dd4182-62d3-4e30-9fe5-e2ec124edca1

"When the current operation requires a FileId and the previous operation
either contains or generates a FileId, if the previous operation fails
with an error, the server SHOULD<253> fail the current operation with
the same error code returned by the previous operation."

>Further, are the two ops then essentially done atomically?

No. They are processed (at least in Samba) as two separate
requests and can be raced by local or other remote access.
