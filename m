From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Watching for changes to a CIFS directory
Date: Fri, 14 Oct 2011 19:25:50 -0500
Message-ID: <CAH2r5muvmXv4jHg_bzy87KT6k62f+0JsJVFnGnY61PGyjgtkjw@mail.gmail.com>
References: <20111014234816.GA14503@esri.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ray Van Dolson <rvandolson-v48TKWNzwFw@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111014234816.GA14503-v48TKWNzwFw@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

inotify code would not be hard to finish - at one time before the vfs
api changed
(to inotify from dnotify) cifs had experimental dnotify code, but it do=
es have
the worker functions for this.   I would be very willing to look at pat=
ches
for this ...

On Fri, Oct 14, 2011 at 6:48 PM, Ray Van Dolson <rvandolson-v48TKWNzwFw@public.gmane.org> w=
rote:
> I'd like to watch a CIFS mounted directory for changes (files being
> created in specific).
>
> Does the CIFS client have working support for either INOTIFY or
> DNOTIFY? =A0From perusing the mailing list, it seems that INOTIFY sup=
port
> is not present, but there was discussion on implementing DNOTIFY
> support some time back[1]. =A0I'm not clear if that was ever partiall=
y or
> fully implemented.
>
> My current test scripts are using DNOTIFY and are not working with th=
e
> CIFS client included in RHEL5, Fedora 13 or Fedora 14.
>
> Thanks,
> Ray
>
> [1] http://lists.samba.org/archive/linux-cifs-client/2009-January/003=
946.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-cifs"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Thanks,

Steve
