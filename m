From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] Add strict cache mode (try #2)
Date: Mon, 1 Nov 2010 08:38:56 +0300
Message-ID: <AANLkTimJ9W=Zx_2YFA0Qt+Skd9FsRUUZ+VZD4jtz-w8D@mail.gmail.com>
References: <AANLkTikQtf_z4AC_29L12rV60t6M99FOjmRuTrG6qN18@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTikQtf_z4AC_29L12rV60t6M99FOjmRuTrG6qN18-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2010/10/31 Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> Here are the set of patches that introduce strict cache semantic into
> the cifs client.
>
> 1. Add strictcache mount option.
> 2. Invalidate inode pages on the last close.
> 3. Add cifs_set_oplock_level.
4. New read logic.
5. New write logic.

-- 
Best regards,
Pavel Shilovsky.
