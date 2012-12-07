From: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Fri, 7 Dec 2012 21:35:20 +0000
Message-ID: <20121207213520.05dd5a3b@pyramind.ukuu.org.uk>
References: <1354818391-7968-1-git-send-email-piastry@etersoft.ru>
	<20121207161602.GA17710@infradead.org>
	<495d17310e0a687d446afc86def0f058@office.etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>,
	<linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, <wine-devel-5vRYHf7vrtgdnm+yROfE0A@public.gmane.org>,
	<linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <495d17310e0a687d446afc86def0f058-Gr3b2bv8/haq3CaADJ+gRi8mxiWnj2XH@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

> The problem is the possibility of denial-of-service attacks here. We 
> can try to prevent them by:
> 1) specifying an extra security bit on the file that indicates that 
> share flags are accepted (like we have for mandatory locks now) and 
> setting it for neccessary files only, or
> 2) adding a special mount option (but it it probably makes sense if we 
> decided to add this support for CIFS and NFS only).

3) making it a property that the process opts into - the same fs can have
Linux and wine users at once.

But for such a big set of changes and with the kind of potential fallout
you need to demonstrate a good practical use case IMHO, not just a "neat
idea I had".

Alan
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
