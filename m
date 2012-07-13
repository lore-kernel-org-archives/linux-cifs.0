From: Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Subject: Re: [PATCH v3 00/32] Get SMB2 mount work
Date: Fri, 13 Jul 2012 14:30:57 +0400
Message-ID: <CAKywueQPMUnJ_LYA5eH9vrGp8+8hBx-63529upde+h4o7=Uz_g@mail.gmail.com>
References: <1342166025-29377-1-git-send-email-pshilovsky@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1342166025-29377-1-git-send-email-pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2012/7/13 Pavel Shilovsky <pshilovsky-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>:
> This version has the following changes:
> 1) patchset included "transport/session code move to ops struct" patchset
> 2) fixed credit patch
> 3) added echo patches
> 4) STATUS_* errors became __constant_cpu_to_le32
> 5) improved coding style
> 6) rebased on top of vfs atomic-open changes
>
> Available on git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-mount

I've also recreated 'for-next' branch that consists the same set of my
patches that Steve's 'for-next' has (but of course on top of
atomic-open changes).

-- 
Best regards,
Pavel Shilovsky.
