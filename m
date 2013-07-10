From: Scott Lovenberg <scott.lovenberg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/8] SMB2 durable handles support
Date: Wed, 10 Jul 2013 10:50:43 -0400
Message-ID: <CAFB9KM0=SOvVqHsarp9KijoUYeG=7=QwnWZMoJDgajbfPH42ZA@mail.gmail.com>
References: <1373450401-4135-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1373450401-4135-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Jul 10, 2013 at 5:59 AM, Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> This patchset implements SMB2 procotol feature -- durable handles. It allows to restore all file handle information after reconnect events. In particular, there is no need to reobtain byte-range locks.
>
> While adding the feature, the patchset simplifies open codepath by introducing new cifs_open_parms structure.
>
> Pavel Shilovsky (8):
>   CIFS: Fix lease context buffer parsing
>   CIFS: Respect create_options in smb2_open_file
>   CIFS: Simplify SMB2_open code path
>   CIFS: Simplify SMB2 create context handling
>   CIFS: Request durable open for SMB2 opens
>   CIFS: Introduce cifs_open_parms struct
>   CIFS: Make SMB2_open use cifs_open_parms struct
>   CIFS: Reconnect durable handles for SMB2
>

Forgive my ignorance, but I thought this patch set was merged a while
ago (around the 4.0 release)?  Is this a respin?


--
Peace and Blessings,
-Scott.
