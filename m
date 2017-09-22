From: Leif Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
Date: Fri, 22 Sep 2017 02:50:09 -0400 (EDT)
Message-ID: <2120555110.8699523.1506063009492.JavaMail.zimbra@redhat.com>
References: <CAH2r5msgp0GsR8zj9ku7CKHB2amUavj1Bd42YELYUqTcVtJ0EA@mail.gmail.com> <CAH2r5mv4ZN9dtpmhDk8_enVPwJqPBoewrVBtV6Hv64QE+saj5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5mv4ZN9dtpmhDk8_enVPwJqPBoewrVBtV6Hv64QE+saj5Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

Looks sane to me.

Rewieved-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


----- Original Message -----
From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Sent: Friday, 22 September, 2017 4:47:46 PM
Subject: Fwd: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens

---------- Forwarded message ----------
From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Fri, Sep 22, 2017 at 1:43 AM
Subject: [SMB3] Handle O_SYNC/DSYNC and O_DIRECT flags on SMB3 opens
To: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>


We were only handling them on CIFS POSIX/Unix mounts.

Fix them for SMB3 (and non-POSIX CIFS) mounts



--
Thanks,

Steve


-- 
Thanks,

Steve
