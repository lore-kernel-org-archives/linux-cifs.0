From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs-utils: cifsacl utilities: Implement getcifsacl
 and setcifsacl
Date: Tue, 23 Aug 2011 07:57:53 -0500
Message-ID: <CADT32eLaVj6PgxW7Ea-a-DF5EH9DwKvt2yEvU7GrxG2H_LMs3Q@mail.gmail.com>
References: <1313810832-2245-1-git-send-email-shirishpargaonkar@gmail.com>
	<20110823085839.41396116@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110823085839.41396116-4QP7MXygkU+dMjc06nkz3ljfA9RmPOcC@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Tue, Aug 23, 2011 at 7:58 AM, Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org> wrote:
> On Fri, 19 Aug 2011 22:27:12 -0500
> shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org wrote:
>
>>
>> Implement utilities getcifsacl and setcifsacl
>>
>>
>> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>
>>
>> Set of patches to build utilities getcifsacl and setcifsacl
>> along with their manpages.
>>
>> getcifsacl fetches a security descriptor of a file off of a
>> share mounted using option cifsacl using API getxattr.
>> It then parses the security descriptor printing control
>> porttion of the security descriptor and then DACL if there
>> is one by printing each ACE with it fields, SID, type, flags, and ma=
sk.
>>
>> setcifsacl builds two lists of ACEs, one specified on the command li=
ne
>> and other fetched from the file the way getcifacl does.
>> It then constructs a security descriptor consisting of ACL
>> and uses API setxattr to send the security descriptor as a blob to
>> the server. =A0setcifsacl also works with files off of shares
>> mounted with option cifsacl.
>>
>> manpages are provided for both the utilities with some examples
>> in setcifsacl manpage. =A0The usage of getcifsacl is simple and
>> very much self explanatory.
>>
>> With these utilities, there is a way to interprete and construct a
>> blob describing security descritpor of a file system object.
>>
>> These utilities are modeled after smbcacls command in the
>> Samba suite.
>>
>
> Other than my comments on the header and the autoconf stuff, I think
> this is probably OK. I do wonder whether time would be better spent o=
n
> getting RichACL's into the VFS, but this certainly doesn't preclude
> that, and seems useful.
>
> One minor nit: you should add the manpages before the autoconf change=
s
> to make sure that bisectability is preserved.
>
> --
> Jeff Layton <jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
>


Jeff, Thanks. Sure. I will also split manpages and auto* rules for getc=
ifacl and
setcifsacl in separate patches.

Regards,

Shirish
