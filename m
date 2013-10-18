From: Simo <simo@samba.org>
Subject: Re: Source for winucase.c
Date: Fri, 18 Oct 2013 10:11:38 -0400
Message-ID: <1382105498.2370.55.camel@pico.ipa.ssimo.org>
References: <1382058269.2794.11.camel@deadeye.wl.decadent.org.uk>
	 <20131018064305.57a78574@tlielax.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
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
> 
> > fs/cifs/winucase.c is commented as:
> > 
> >  * The const tables in this file were converted from the following info
> >  * provided by Microsoft:
> >  *
> >  * 3.1.5.3 Mapping UTF-16 Strings to Upper Case:
> >  *
> >  * http://msdn.microsoft.com/en-us/library/hh877830.aspx
> >  * http://www.microsoft.com/en-us/download/details.aspx?displaylang=en&id=10921
> >  *
> >  * In particular, the table in "Windows 8 Upper Case Mapping Table.txt" was
> >  * post-processed using the winucase_convert.pl script.
> > 
> > Isn't "Windows 8 Upper Case Mapping Table.txt" then the preferred form
> > for modification of the tables?  In which case, it should be included in
> > the kernel sources.
> > 
> > Also, shouldn't this file acknowledge Microsoft's copyright, if it's a
> > derivative work of their file?
> > 
> > Ben.
> > 
> 
> (cc'ing samba-technical and Bradley Kuhn in the hopes that he can help
> clarify)
> 
> Good questions. I'm not certain on either point. When I queried the MS
> folks about the licensing on that file, they said:
> 
> "I discovered the content you used is in fact referenced by the
>  MS-UCODEREF document, in section 3.1.5.2.3.1   Windows Sorting Weight
>  Table. I discussed with the appropriate folks here, and for use in
>  Samba it's certainly covered under Samba's existing PFIF license."
> 
> Bradley, any thoughts as to Ben's questions?
> 

The file from Microsoft in fact does not contain a Copyright Header.

IANAL, but a collection of facts is hardly copyrightable material
anyway.

These tables cannot be arbitrarily changed some even if they were
copyrightable they would probably fall under various fair use or
interoperability exceptions in different laws at least in US and EU.

Simo.
