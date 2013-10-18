From: Andrew Bartlett <abartlet@samba.org>
Subject: Re: Source for winucase.c
Date: Sat, 19 Oct 2013 08:44:59 +1300
Message-ID: <1382125499.18726.10.camel@jesse>
References: <1382058269.2794.11.camel@deadeye.wl.decadent.org.uk>
	 <20131018064305.57a78574@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Cc: linux-cifs@vger.kernel.org, "Bradley M. Kuhn" <bkuhn@sfconservancy.org>, Ben Hutchings <ben@decadent.org.uk>, samba-technical@lists.samba.org
To: Jeff Layton <jlayton@redhat.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20131018064305.57a78574@tlielax.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Fri, 2013-10-18 at 06:43 -0400, Jeff Layton wrote:
> On Fri, 18 Oct 2013 02:04:29 +0100
> Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > fs/cifs/winucase.c is commented as:
> >=20
> >  * The const tables in this file were converted from the following in=
fo
> >  * provided by Microsoft:
> >  *
> >  * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
> >  *
> >  * http://msdn.microsoft.com/en-us/library/hh877830.aspx
> >  * http://www.microsoft.com/en-us/download/details.aspx?displaylang=3D=
en&id=3D10921
> >  *
> >  * In particular, the table in "Windows 8 Upper Case Mapping Table.tx=
t" was
> >  * post-processed using the winucase_convert.pl script.
> >=20
> > Isn't "Windows 8 Upper Case Mapping Table.txt" then the preferred for=
m
> > for modification of the tables?  In which case, it should be included=
 in
> > the kernel sources.
> >=20
> > Also, shouldn't this file acknowledge Microsoft's copyright, if it's =
a
> > derivative work of their file?
> >=20
> > Ben.
> >=20
>=20
> (cc'ing samba-technical and Bradley Kuhn in the hopes that he can help
> clarify)
>=20
> Good questions. I'm not certain on either point. When I queried the MS
> folks about the licensing on that file, they said:
>=20
> "I discovered the content you used is in fact referenced by the
>  MS-UCODEREF document, in section 3.1.5.2.3.1   Windows Sorting Weight
>  Table. I discussed with the appropriate folks here, and for use in
>  Samba it's certainly covered under Samba's existing PFIF license."
>=20
> Bradley, any thoughts as to Ben's questions?

The worked 'referenced' is the key point, because these are the terms on
the WSPP docs on their website:

Copyrights. This documentation is covered by Microsoft copyrights.
Regardless of any other terms that are contained in the terms of use for
the Microsoft website that hosts this documentation, you may make copies
of it in order to develop implementations of the technologies described
in the Open Specifications and may distribute portions of it in your
implementations using these technologies or your documentation as
necessary to properly document the implementation. You may also
distribute in your implementation, with or without modification, any
schema, IDL=E2=80=99s, or code samples that are included in the documenta=
tion.
This permission also applies to any documents that are referenced in the
Open Specifications.=20

The last line is what they are referring to.

Andrew Bartlett

--=20
Andrew Bartlett                                http://samba.org/~abartlet=
/
Authentication Developer, Samba Team           http://samba.org
