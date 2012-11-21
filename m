From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 0/3] Add O_DENY* flags to fcntl and cifs
Date: Wed, 21 Nov 2012 18:47:16 +0400
Message-ID: <CAKywueT_d_aUbeNvFx0N8cQeK0F=WbjomjGrNBcr5GjYy=_F_A@mail.gmail.com>
References: <1353507930-10908-1-git-send-email-piastry@etersoft.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1353507930-10908-1-git-send-email-piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/11/21 Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>:
> Network filesystems CIFS, SMB2.0, SMB3.0 and NFSv4 have such flags - this change can benefit cifs and nfs modules. While this change is ok for network filesystems, itsn't not targeted for local filesystems due security problems (e.g. when a user process can deny root to delete a file).
>
> Share flags are used by Windows applications and WINE have to deal with them too. While WINE can process open share flags itself on local filesystems, it can do it if a file stored on netowork share and is used by several clients. This patchset makes it possible.
Sorry for the typo, should be: "While WINE can..., it can _not_ do it
if a file is stored on a network share and used by several clients."

-- 
Best regards,
Pavel Shilovsky.
