From: Kyle Lippincott <fusedevel-FeTeImpVCmasTnJN9+BGXg@public.gmane.org>
Subject: Re: Design of fsnotify for FUSE,
 nfs and cifs: when/how to send a watch.
Date: Mon, 25 Apr 2016 17:13:17 -0700
Message-ID: <CAOo72F3TWM8b6ewS46mT-NoOtYGvCdM9wTXcpk3j-XauUTkd3A@mail.gmail.com>
References: <CANXojcz-U4YzgUhDRgvoVX=n756oVg4nvvvwpimmpBJyLkkmoQ@mail.gmail.com>
	<CANXojcwF1ePzsLjpVbPZNdQTO6wG3xh2GQe6fPNJ5H4sZur-mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============0735182746054966895=="
Cc: "fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <CANXojcwF1ePzsLjpVbPZNdQTO6wG3xh2GQe6fPNJ5H4sZur-mA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=fuse-devel>
List-Post: <mailto:fuse-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/fuse-devel>,
	<mailto:fuse-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: fuse-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-cifs.vger.kernel.org

--===============0735182746054966895==
Content-Type: multipart/alternative; boundary=001a1143a1b2f0c86605315828c8

--001a1143a1b2f0c86605315828c8
Content-Type: text/plain; charset=UTF-8

I skimmed the document, thank you for considering my concern regarding the
IN_REMOTE requirement; I'm excited to have this available.

On Thu, Apr 21, 2016 at 12:26 AM, Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Hi,
>
> the links does not work. The trailing dot causes this. Goto the wiki
> and select the right page:
>
> https://github.com/libfuse/libfuse/wiki
>
> Stef
>
>
> ------------------------------------------------------------------------------
> Find and fix application performance issues faster with Applications
> Manager
> Applications Manager provides deep performance insights into multiple
> tiers of
> your business applications. It resolves application problems quickly and
> reduces your MTTR. Get your free trial!
> https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
> --
> fuse-devel mailing list
> To unsubscribe or subscribe, visit
> https://lists.sourceforge.net/lists/listinfo/fuse-devel
>

--001a1143a1b2f0c86605315828c8
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I skimmed the document, thank you for considering my conce=
rn regarding the IN_REMOTE requirement; I&#39;m excited to have this availa=
ble.=C2=A0</div><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">O=
n Thu, Apr 21, 2016 at 12:26 AM, Stef Bon <span dir=3D"ltr">&lt;<a href=3D"=
mailto:stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" target=3D"_blank">stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org</a>&gt;</span=
> wrote:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;bo=
rder-left:1px #ccc solid;padding-left:1ex">Hi,<br>
<br>
the links does not work. The trailing dot causes this. Goto the wiki<br>
and select the right page:<br>
<br>
<a href=3D"https://github.com/libfuse/libfuse/wiki" rel=3D"noreferrer" targ=
et=3D"_blank">https://github.com/libfuse/libfuse/wiki</a><br>
<span class=3D"HOEnZb"><font color=3D"#888888"><br>
Stef<br>
</font></span><div class=3D"HOEnZb"><div class=3D"h5"><br>
---------------------------------------------------------------------------=
---<br>
Find and fix application performance issues faster with Applications Manage=
r<br>
Applications Manager provides deep performance insights into multiple tiers=
 of<br>
your business applications. It resolves application problems quickly and<br=
>
reduces your MTTR. Get your free trial!<br>
<a href=3D"https://ad.doubleclick.net/ddm/clk/302982198;130105516;z" rel=3D=
"noreferrer" target=3D"_blank">https://ad.doubleclick.net/ddm/clk/302982198=
;130105516;z</a><br>
--<br>
fuse-devel mailing list<br>
To unsubscribe or subscribe, visit <a href=3D"https://lists.sourceforge.net=
/lists/listinfo/fuse-devel" rel=3D"noreferrer" target=3D"_blank">https://li=
sts.sourceforge.net/lists/listinfo/fuse-devel</a><br>
</div></div></blockquote></div><br></div>

--001a1143a1b2f0c86605315828c8--


--===============0735182746054966895==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

------------------------------------------------------------------------------
Find and fix application performance issues faster with Applications Manager
Applications Manager provides deep performance insights into multiple tiers of
your business applications. It resolves application problems quickly and
reduces your MTTR. Get your free trial!
https://ad.doubleclick.net/ddm/clk/302982198;130105516;z
--===============0735182746054966895==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

-- 
fuse-devel mailing list
To unsubscribe or subscribe, visit https://lists.sourceforge.net/lists/listinfo/fuse-devel

--===============0735182746054966895==--
