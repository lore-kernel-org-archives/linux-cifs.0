From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: lanman auth
Date: Mon, 14 Feb 2011 21:41:36 -0600
Message-ID: <AANLkTikV2cWmEnj=nPCPYPPsMCYErTf-P6a9XuLqXU03@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

FYI - Looks like we may have a problem with lanman auth according to
Shirish's debugging.  Although lanman auth is disabled by default in
the build and few servers require it - still probably worth fixing
quickly.

-- 
Thanks,

Steve
