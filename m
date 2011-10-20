From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cifs: Assume passwords are encoded according to iocharset
 (try #2)
Date: Thu, 20 Oct 2011 15:58:33 -0500
Message-ID: <CADT32eL3EZPcQwFusK+Lvg_sFzmDvOg=0GEFHh49Z9qP7qBD9Q@mail.gmail.com>
References: <1319134919-4300-1-git-send-email-shirishpargaonkar@gmail.com>
	<20111020151300.5fd507ba@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20111020151300.5fd507ba-9yPaYZwiELC+kQycOl6kW4xkIHaj4LzF@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Oct 20, 2011 at 2:13 PM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Thu, 20 Oct 2011 13:21:59 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>> From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Re-posting a patch originally posted by Oskar Liljeblad after
>> rebasing on 3.2.
>>
>>
>> Modify cifs to assume that the supplied password is encoded accordin=
g
>> to iocharset. =A0Before this patch passwords would be treated as
>> raw 8-bit data, which made authentication with Unicode passwords imp=
ossible
>> (at least passwords with characters > 0xFF).
>>
>> The previous code would as a side effect accept passwords encoded wi=
th
>> ISO 8859-1, since Unicode < 0x100 basically is ISO 8859-1. =A0Softwa=
re which
>> relies on that will no longer support password chars > 0x7F unless i=
t also
>> uses iocharset=3Diso8859-1. =A0(mount.cifs does not care about the e=
ncoding so
>> it will work as expected.)
>>
>> Signed-off-by: Oskar Liljeblad <oskar-Y7VfMkPRzygsCylrc8G9yg@public.gmane.org>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> Tested-by: A <nimbus1_03087-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
>
>
> I don't know about this. What happens if I have characters in my
> password that are not part of the current iocharset? I guess I'm
> screwed?
>
> The iocharset (and on smbfs, the remotenls) really only referred to t=
he
> encoding/decoding of filenames. What's the justification for assuming
> that the password ought to be governed by that as well?
>
> If you're mounting with a cred file, is it really correct to assume
> that it's encoded according to the local charset? It seems like if I
> have the password stored in a credential file that it ought to work
> even if I copy it to a host that uses a different iocharset for
> encoding and decoding filenames.
>
> Would it be better to have userspace encode the password instead so
> that you have some flexibility if it's impossible to encode your
> password in the current iocharset?
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>

=46or a successful authentication, password blob at
the client, however generated, has to match the blob
that is used at the server in order to generate a
correct ntlm response.

I think we ought to have a mount option that specifies the
codepage of the server.

If my current codepage (e.g. the default of utf8) does not
a character (e.g. umlaut) that is part of the password at the
server and part of the codepage at the server, I will fail
authentication.

The new mount options should state its purpose in the
man page i.e. its use is limited to password translation.

Because password is used in calculating ntlm response,
we will have to have code value of a character as per the
codepage at the server to genereate correct hashes
and ntlm response blob in cifs module.

But if the codepage on the client is different or smaller
subset of the codepage at the server, how would each
character of a password blob be identified/distinguished
in order to convert it to that belonging to the code page
at the server such that new blob is used during
ntlm response calculation?

Regards,

Shirish
