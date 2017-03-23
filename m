From: Jan-Marek Glogowski <glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Subject: Re: [PATCH] Reset TreeId to zero on SMB2 TREE_CONNECT
Date: Thu, 23 Mar 2017 19:17:27 +0100
Message-ID: <efd254dc-ecd6-5ea7-7850-b287c64071c2@fbihome.de>
References: <1487589958-20489-1-git-send-email-glogow@fbihome.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 7bit
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487589958-20489-1-git-send-email-glogow-iG8UcmBuX++ELgA04lAiVw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi everyone,

just replying to my own patch mail.

The patch is now pending for a month. I saw other stuff picked up for
linux-next and wondered, if it was missing something?

The patch was developed with the help of Aurelien Aptel, originally in
the "Fix SMB2_TREE_CONNECT requests with the wrong TreeId" thread
starting 2017-02-10.

There is a bug report with an attached trace and my debug scripts at
https://bugzilla.samba.org/show_bug.cgi?id=12584

Best regards,

Jan-Marek Glogowski
