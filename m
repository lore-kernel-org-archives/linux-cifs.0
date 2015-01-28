From: Namjae Jeon <namjae.jeon-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: The patents and license issue from microsoft regarding SMB
 implementation(GPL)
Date: Wed, 28 Jan 2015 11:24:41 +0900
Message-ID: <000801d03aa1$92475b40$b6d611c0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-language: ko
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi Folks,

I am planning to develop smb server for Linux kernel.
Before starting on implemntation, want to clear patent related issue
to know if it is legal to develop or not.

When referring to the SAMBA site
(https://www.samba.org/samba/PFIF/PFIF_history.html), I can see that there are
a lot of legal obligations from the past. Like SAMBA, I also am just
referring the Microsoft SPEC, while the implementation is all together different 
due to obvious reasons (in-kernel implementation).
As there is already an in kernel CIFS client, maybe CIFS developers had the same
concern when developing CIFS client for Linux kernel ?
But I'm not sure about the actual violation part.
Maybe, I am wondering two problem.
 1. When referring the Microsoft patent list, CIFS(SMB) and SMB2.0,
    Microsoft have raised patent applications but this overall seems to be
    about the implementation part. So, any implementation done on linux
    with SMB specifications in mind and not following the approach of Microsoft
    should not infringe any patents ?
 2. While Samba have shifted to the GPLv3 with their newer version, but
    I intend to make GPLv2.0 SMB server in kernel.
    So implementation for this should not cause any license issues ?

Can you please help us in clearing the doubts ?

Thanks.
