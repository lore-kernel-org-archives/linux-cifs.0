From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cifs: Call id to SID mapping functions to change
 owner/group (try #2)
Date: Tue, 28 Jun 2011 07:51:52 -0500
Message-ID: <BANLkTi=o5dp6Vz+JccZz8BxW3YHDffcgkw@mail.gmail.com>
References: <1308607283-17038-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110624134300.2b9411bc@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110624134300.2b9411bc-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Jun 24, 2011 at 12:43 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote=
:
> On Mon, 20 Jun 2011 17:01:23 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Now build security descriptor to change either owner or group at the
>> server. =A0Initially security descriptor was built to change only
>> ACL, that functionality has been extended.
>>
>> When either an Owner or Group of a file object at the server is chan=
ged,
>> rest of security descriptor remains same (DACL etc.).
>>
>> To set security descriptor, it is essential to open that file
>> with WRITE_DAC as well as WRITE_OWNER (Take Ownership) permission bi=
ts.
>> Function set_cifs_acl_by_fid() has been removed since we can't be
>> sure how a file was opened for writing, a valid request can fail
>> if the file was not opened with two above mentioned permissions.
>>
>> It is the server that decides whether a set security descriptor with
>> either owner or group change succeeds or not.
>>
>
> I'd like to see an explanation for what problem this solves and why
> this is useful.
>
> Why should I care about this set? With this, what can I do that I
> couldn't do before -- chown()/chgrp()? Also, how was this set tested?
> In particular I'd like to understand how you tested the part that
> handles chown(). Doesn't that require mounting as a user that has
> elevated permissions?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

Jeff, basically, cifs client is making sure that when it sends a
security descriptor to be set, it sends with a valid and legit SID,
otherwise it does not. It does not change the DACL.
And then let the server decide whether set security descriptor
should succeed or not.
If the authenticated user does not have write_owner and write_dac
permissions on the object, open at the server would fail too so
there would not be any set security descriptor call going through to
the server at all.

Regards,

Shirish
