From: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cifscreds: check optind before accessing argv[optind]
Date: Mon, 22 Jan 2018 19:57:40 -0500 (EST)
Message-ID: <1836982403.1740018.1516669060551.JavaMail.zimbra@redhat.com>
References: <20180123004801.10182-1-lsahlber@redhat.com> <CAH2r5ms-rpxf5E_XZc1W+h1tMmV26WEbXWCxEfYa+cA7PX-VTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: CIFS <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
        Pavel Shilovsky <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAH2r5ms-rpxf5E_XZc1W+h1tMmV26WEbXWCxEfYa+cA7PX-VTw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>





----- Original Message -----
> From: "Steve French" <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> To: "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: "CIFS" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Pavel Shilovsky" <piastryyy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Sent: Tuesday, 23 January, 2018 11:50:38 AM
> Subject: Re: [PATCH] cifscreds: check optind before accessing argv[optind]
> 
> I would like to add cc stable. Ok?

SGTM

> 
> On Jan 22, 2018 18:48, "Ronnie Sahlberg" <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > Redhat bugzilla: 1278543
> >
> > This fixes a segfault for some incorrect usage, for example
> >    cifscreds -u test
> >
> > Signed-off-by: Ronnie Sahlberg <lsahlber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > ---
> >  cifscreds.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/cifscreds.c b/cifscreds.c
> > index 5d84c3c..32f2ee4 100644
> > --- a/cifscreds.c
> > +++ b/cifscreds.c
> > @@ -487,6 +487,9 @@ int main(int argc, char **argv)
> >                 }
> >         }
> >
> > +       if (optind >= argc)
> > +               return usage();
> > +
> >         /* find the best fit command */
> >         best = NULL;
> >         n = strnlen(argv[optind], MAX_COMMAND_SIZE);
> > --
> > 2.15.1
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-cifs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
