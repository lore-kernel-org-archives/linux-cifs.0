From: Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to test multiusermount?
Date: Fri, 4 Nov 2011 11:25:43 -0500
Message-ID: <CAH2r5muM1_pftwtc=C29-jV5HC-SrwCanmEFPwkDxQpyO6f=rg@mail.gmail.com>
References: <CANXojcwxf0aD=_18_6D6=WkG86F9Qx4PTf7F=2husGbASac6hA@mail.gmail.com>
	<20111101060428.5d474bb9@tlielax.poochiereds.net>
	<4EB37983.3080607@suse.com>
	<CAH2r5mtAbBhRj6SSB5TNWW4OtTJhno7szPH7FR6tn0rS1FB6=w@mail.gmail.com>
	<20111104100231.57ad94d6@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Suresh Jayaraman <sjayaraman-IBi9RG/b67k@public.gmane.org>,
	Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	linux-cifs <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111104100231.57ad94d6-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Nov 4, 2011 at 9:02 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 4 Nov 2011 00:56:16 -0500
> Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> On Fri, Nov 4, 2011 at 12:34 AM, Suresh Jayaraman <sjayaraman@suse.c=
om> wrote:
>> > On 11/01/2011 03:34 PM, Jeff Layton wrote:
>> >> On Tue, 1 Nov 2011 00:12:21 +0100
>> >> Stef Bon <stefbon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> >>
>> >>> Hi,
>> >>>
>> >>> I would like to test the multiusermounts?
>> >>>
>> >>> I know to set:
>> >>>
>> >>> =A0echo 1 > /proc/fs/cifs/MultiuserMount
>> >>>
>> >>> and add an option to the mount command, but I can remember/read =
somewhere
>> >>> that one have to add some mapping somehwere:
>> >>>
>> >>> local user : remote user
>> >>> ...
>> >>>
>> >>> Is this correct?
>> >>>
>> >>
>> >> No. The MultiuserMount code that the above switch activates is
>> >> basically deprecated (and never worked very well in the first pla=
ce).
>> >
>> > So, time for planning its good riddance?
>>
>> Mainly waiting for some way to have ntlmv2 enablement of multiuser
>> mount (krb5 only is too restrictive).
>>
>
> Right. The new multiuser code only works with krb5 so far. I
> think in order to deprecate the old code, we need to do the following=
:
>
> 1) the cifscreds program in cifs-utils will need to be cleaned up and
> completed. This would allow users to stash their NTLM creds in the
> kernel's keyring. This includes username and password, and some info
> about which creds should be used with which servers (or NT domains).
> The existing format for stashing those creds is probably not what we
> need so this is a bit of work and redesign I think.
>
> 2) code will need to be added to the kernel to fetch NTLM auth info o=
ut
> of the kernel keyring for establishing new sessions.
>
> 3) better documentation for multiuser mounts. This is always an issue=
,
> but multiuser is more complicated so we'll really need this.
>
> At that point, I think we can schedule the old multiuser code for
> deprecation.

Yes.  Also note probable need for optional winbind integration
to fetch creds (or winbind -> kernel keyring tie so we can get
at these creds as needed)

--=20
Thanks,

Steve
