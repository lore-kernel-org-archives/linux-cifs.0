From: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/5] cifs-utils: cifsacl utilities: Implement getcifsacl
 and setcifsacl
Date: Mon, 22 Aug 2011 08:34:40 -0500
Message-ID: <CADT32e+6hMXmuJUiAYvp5HCbzLDmOdv7pMTMJcSiViK9KNONjg@mail.gmail.com>
References: <1313810832-2245-1-git-send-email-shirishpargaonkar@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: jlayton-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1313810832-2245-1-git-send-email-shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Fri, Aug 19, 2011 at 10:27 PM,  <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> Implement utilities getcifsacl and setcifsacl
>
>
> Signed-off-by: Shirish Pargaonkar <shirishpargaonkar-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
>
> Set of patches to build utilities getcifsacl and setcifsacl
> along with their manpages.
>
> getcifsacl fetches a security descriptor of a file off of a
> share mounted using option cifsacl using API getxattr.
> It then parses the security descriptor printing control
> porttion of the security descriptor and then DACL if there
> is one by printing each ACE with it fields, SID, type, flags, and mas=
k.
>
> setcifsacl builds two lists of ACEs, one specified on the command lin=
e
> and other fetched from the file the way getcifacl does.
> It then constructs a security descriptor consisting of ACL
> and uses API setxattr to send the security descriptor as a blob to
> the server. =A0setcifsacl also works with files off of shares
> mounted with option cifsacl.
>
> manpages are provided for both the utilities with some examples
> in setcifsacl manpage. =A0The usage of getcifsacl is simple and
> very much self explanatory.
>
> With these utilities, there is a way to interprete and construct a
> blob describing security descritpor of a file system object.
>
> These utilities are modeled after smbcacls command in the
> Samba suite.
>
>

Jeff, any comments on these?

Regards,

Shirish
