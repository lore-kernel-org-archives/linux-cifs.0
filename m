From: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH] SMB: fix memory leak in smb3_validate_negotiate
Date: Fri, 20 Oct 2017 14:49:36 +0200
Message-ID: <20171020124938.9913-1-ddiss@suse.de>
References: <20171020102033.22936-1-shuwang@redhat.com>
To: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, sfrench-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org,
        linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171020102033.22936-1-shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

> From: Shu Wang <shuwang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Found the issue by kmemleak. The pointer pneg_rsp stores the
> pointer kmalloced from SMB2_ioctl, and should be release
> before function return.

Thanks for the patch, Shu Wang. A fix for this memory leak is already
queued at https://bugzilla.samba.org/show_bug.cgi?id=13092 , alongside
an extra fix for potential use of uninitialised memory. Patches to
follow...

Cheers, David
