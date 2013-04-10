From: Marc Haber <mh+linux-cifs-ciUMMiFYEj8OIzVOb1FTxg@public.gmane.org>
Subject: Re: Cannot mount Canon Scanner CIFS share with cifs while
 smbclient works
Date: Wed, 10 Apr 2013 23:23:18 +0200
Message-ID: <20130410212318.GA2114@torres.zugschlus.de>
References: <20130408194049.GE10949@torres.zugschlus.de>
 <20130410090415.7e1c40b3@corrin.poochiereds.net>
 <20130410184639.GB31333@torres.zugschlus.de>
 <CAH2r5msWFVuQFVb2fNn7W-_Gp8Uf4phE1Xd3h9HU0AOewzJHPg@mail.gmail.com>
 <20130410200746.GB515@torres.zugschlus.de>
 <CAH2r5muGsam56ShjokfTUGko+UPxoOgd=45TTJK5rCWkZsQuzw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muGsam56ShjokfTUGko+UPxoOgd=45TTJK5rCWkZsQuzw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Wed, Apr 10, 2013 at 03:41:01PM -0500, Steve French wrote:
> Given that it worked before probably better to try "sec=ntlm" (or
> "sec=ntlmv2") since that will send what we used to send.

sec=ntlm worked, thanks.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
