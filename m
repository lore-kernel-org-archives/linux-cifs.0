From: Pavel Shilovsky <piastry-7qunaywFIewox3rIn2DAYQ@public.gmane.org>
Subject: Re: [PATCH 2/2] CIFS: Simplify invalidate part (try #2)
Date: Fri, 22 Apr 2011 23:02:00 +0400
Message-ID: <BANLkTimshAUzTSE0UE9xR5b4sZihdCrdYQ@mail.gmail.com>
References: <1302635430-3575-1-git-send-email-piastry@etersoft.ru>
	<BANLkTi=7eNfZXZPWYoPYY1CWsKqwvXkKNA@mail.gmail.com>
	<BANLkTikfXi9U2A88S1_h8kXfyNhJcs9rzw@mail.gmail.com>
	<20110422075007.2e9c303b@tlielax.poochiereds.net>
	<BANLkTinMswT8Sur+Kv5JGb3jbObKnSC1mg@mail.gmail.com>
	<20110422101050.1472e618@tlielax.poochiereds.net>
	<BANLkTi=OmEDN-iFv_Tjg96_WshcJTvaXyQ@mail.gmail.com>
	<20110422110724.0846b1b0@tlielax.poochiereds.net>
	<BANLkTikzfTm00+u5uBo1E7cO_JaRtZkMVQ@mail.gmail.com>
	<20110422125906.622a281b@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	Suresh Jayaraman <sjayaraman-l3A5Bk7waGM@public.gmane.org>,
	linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110422125906.622a281b-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

2011/4/22 Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>:
> Used to be synchronous. One of the goals of the async write patchset
> I'm working on is to change that.

In this case, what do you think about to call filemap_fdatawait before
update attributes in gettattr and llseek? It seems that it makes us
sure that all dirty pages are written and we can get right file
attributes from the server.

-- 
Best regards,
Pavel Shilovsky.
