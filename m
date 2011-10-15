From: Ray Van Dolson <rvandolson-v48TKWNzwFw@public.gmane.org>
Subject: Re: Watching for changes to a CIFS directory
Date: Fri, 14 Oct 2011 17:48:03 -0700
Message-ID: <20111015004803.GA16338@esri.com>
References: <20111014234816.GA14503@esri.com>
 <CAH2r5muvmXv4jHg_bzy87KT6k62f+0JsJVFnGnY61PGyjgtkjw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAH2r5muvmXv4jHg_bzy87KT6k62f+0JsJVFnGnY61PGyjgtkjw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Oct 14, 2011 at 05:25:50PM -0700, Steve French wrote:
> inotify code would not be hard to finish - at one time before the vfs
> api changed (to inotify from dnotify) cifs had experimental dnotify
> code, but it does have the worker functions for this.   I would be
> very willing to look at patches for this ...

Thanks Steve.  If only I had the skills to create the patches!

Appreciate the info.

Ray

>=20
> On Fri, Oct 14, 2011 at 6:48 PM, Ray Van Dolson <rvandolson-v48TKWNzwFw@public.gmane.org>=
 wrote:
> > I'd like to watch a CIFS mounted directory for changes (files being
> > created in specific).
> >
> > Does the CIFS client have working support for either INOTIFY or
> > DNOTIFY? =A0From perusing the mailing list, it seems that INOTIFY s=
upport
> > is not present, but there was discussion on implementing DNOTIFY
> > support some time back[1]. =A0I'm not clear if that was ever partia=
lly or
> > fully implemented.
> >
> > My current test scripts are using DNOTIFY and are not working with =
the
> > CIFS client included in RHEL5, Fedora 13 or Fedora 14.
> >
> > Thanks,
> > Ray
> >
> > [1] http://lists.samba.org/archive/linux-cifs-client/2009-January/0=
03946.html
