From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: allow admins to specify an alternate krb5.conf file
Date: Tue, 10 Jan 2012 13:18:53 -0600
Message-ID: <CADT32eLroF4EoreYdNqgA2V7H+4YNBt9_oke=HFa8ZsHG9UvhA@mail.gmail.com>
References: <1326220007-527-1-git-send-email-jlayton@samba.org>
	<CADT32eJ_Md78_eZ_zyox55GOy=2dsRjZXs-QAVELZD9eGAUQXA@mail.gmail.com>
	<20120110141626.6545c293@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120110141626.6545c293-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Jan 10, 2012 at 1:16 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Tue, 10 Jan 2012 13:04:53 -0600
> Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Tue, Jan 10, 2012 at 12:26 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wr=
ote:
>> > This was actually requested by the Red Hat QA group, who sometimes=
 work
>> > with multiple krb5.conf files when testing.
>> >
>> > Requested-by: Marko Myllynen <myllynen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> > Signed-off-by: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>> > ---
>> > =A0cifs.upcall.8.in | =A0 =A08 +++++++-
>> > =A0cifs.upcall.c =A0 =A0| =A0 13 ++++++++++---
>> > =A02 files changed, 17 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/cifs.upcall.8.in b/cifs.upcall.8.in
>> > index 0d79a99..3ae0562 100644
>> > --- a/cifs.upcall.8.in
>> > +++ b/cifs.upcall.8.in
>> > @@ -22,7 +22,7 @@
>> > =A0cifs.upcall \- Userspace upcall helper for Common Internet File=
 System (CIFS)
>> > =A0.SH "SYNOPSIS"
>> > =A0.HP \w'\ 'u
>> > -cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\=
-uid|\-l] {keyid}
>> > +cifs\&.upcall [\-\-trust\-dns|\-t] [\-\-version|\-v] [\-\-legacy\=
-uid|\-l] [--krb5conf=3D/path/to/krb5.conf|-k /path/to/...] {keyid}
>> > =A0.SH "DESCRIPTION"
>> > =A0.PP
>> > =A0This tool is part of the cifs-utils suite\&.
>> > @@ -38,6 +38,12 @@ for a particular key type\&. While it can be ru=
n directly from the command\-line
>> > =A0This option is deprecated and is currently ignored\&.
>> > =A0.RE
>> > =A0.PP
>> > +\--krb5conf=3D/path/to/krb5.conf|-k /path/to/krb5.conf
>> > +.RS 4
>> > +This option allows administrators to set an alternate location fo=
r the
>> > +krb5.conf file that cifs.upcall will use.
>> > +.RE
>> > +.PP
>> > =A0\-\-trust\-dns|\-t
>> > =A0.RS 4
>> > =A0With krb5 upcalls, the name used as the host portion of the ser=
vice principal defaults to the hostname portion of the UNC\&. This opti=
on allows the upcall program to reverse resolve the network address of =
the server in order to get the hostname\&.
>> > diff --git a/cifs.upcall.c b/cifs.upcall.c
>> > index f560d21..0d222cb 100644
>> > --- a/cifs.upcall.c
>> > +++ b/cifs.upcall.c
>> > @@ -759,12 +759,13 @@ lowercase_string(char *c)
>> >
>> > =A0static void usage(void)
>> > =A0{
>> > - =A0 =A0 =A0 fprintf(stderr, "Usage: %s [-t] [-v] [-l] key_serial=
\n", prog);
>> > + =A0 =A0 =A0 fprintf(stderr, "Usage: %s [-k /path/to/krb5.conf] [=
-t] [-v] [-l] key_serial\n", prog);
>> > =A0}
>> >
>> > =A0const struct option long_options[] =3D {
>> > - =A0 =A0 =A0 {"trust-dns", 0, NULL, 't'},
>> > + =A0 =A0 =A0 {"krb5conf", 1, NULL, 'k'},
>> > =A0 =A0 =A0 =A0{"legacy-uid", 0, NULL, 'l'},
>> > + =A0 =A0 =A0 {"trust-dns", 0, NULL, 't'},
>> > =A0 =A0 =A0 =A0{"version", 0, NULL, 'v'},
>> > =A0 =A0 =A0 =A0{NULL, 0, NULL, 0}
>> > =A0};
>> > @@ -792,7 +793,7 @@ int main(const int argc, char *const argv[])
>> >
>> > =A0 =A0 =A0 =A0openlog(prog, 0, LOG_DAEMON);
>> >
>> > - =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "cltv", long_o=
ptions, NULL)) !=3D -1) {
>> > + =A0 =A0 =A0 while ((c =3D getopt_long(argc, argv, "ck:ltv", long=
_options, NULL)) !=3D -1) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0switch (c) {
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'c':
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* legacy option --=
 skip it */
>> > @@ -800,6 +801,12 @@ int main(const int argc, char *const argv[])
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 't':
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0try_dns++;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 case 'k':
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (setenv("KRB5_CON=
=46IG", optarg, 1) !=3D 0) {
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sysl=
og(LOG_ERR, "unable to set $KRB5_CONFIG: %d", errno);
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto=
 out;
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
>> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0case 'l':
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0legacy_uid++;
>> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
>> > --
>> > 1.7.7.4
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe linux-ci=
fs" in
>> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>
>> Who does getenv on KRB5_CONFIG?
>>
>
> The krb5 libraries.
>
>> Also, is the name of the environment variable as KRB5_CONFIG, decide=
d?
>> It is a common name, perhaps we can change it to something like
>> CIFS_KRB5_CONFIG (and mention it in the manpage) to make it
>> cifs (upcall) specific?
>
> It's a well-known environment variable that affects what krb5.conf th=
e
> krb5 libs will use. What would be the point of changing the name?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>

got it.  Patch looks fine then.

Acked-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
