From: Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: SMB2 dev status
Date: Fri, 30 Dec 2011 01:50:24 +0400
Message-ID: <CAKywueQx=bdMPD2Ws2W7NWCZz_X=36W8mFhL7+rQ9Rc5MUZRog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Hi all!

I will be on holidays for about a week or a little more (will check
email box). I pushed the last status of SMB2 patches into smb2-dev
branch:
http://git.altlinux.org/people/piastry/public/?p=cifs-2.6.git;a=shortlog;h=refs/heads/smb2-dev

It's not the final variant - that's why I didn't posted them to the
list. There is still some work to be done - I want to drop the first
patch "CIFS: Add structure definitions for SMB2 PDUs" and add each PDU
structure with it's first usage.

So, can you look and comment if possible on the approach and design of
this version of the patch series, please?

-- 
Best regards,
Pavel Shilovsky.
