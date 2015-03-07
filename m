From: Saket Sinha <saket.sinha89@gmail.com>
Subject: Re: GSOC 2015 Aspirant for Improving SMB3 protocol improvements
Date: Fri, 6 Mar 2015 16:43:22 -0800
Message-ID: <CAK25hWMk0JJwhPX=hNSgzwY_yf5Sk-OjMPU_GavYqiZgHrPPBg@mail.gmail.com>
References: <CAK25hWMTkzSun5jD_8fLzBiROoD4h8oejZQPai9rwB8WqAENOA@mail.gmail.com>
	<20150304133141.35b0d72c@plati.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Steve French <smfrench@gmail.com>, samba-technical@lists.samba.org,
	linux-cifs@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <20150304133141.35b0d72c@plati.site>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
	<mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

Hi David,

        I have tried reaching out to linux-cifs mailing list and Steve
French earlier even but haven't found much of a response form either one.
I guess this mailing list is not that friendly to novice and only cater
needs and discussions of frequent commiters and core samba developers.

If I do not get a response here, is there any where else I can ask for help
for getting started  ?

Regards,
Saket SInha







Regards,
Saket Sinha

On Wed, Mar 4, 2015 at 4:31 AM, David Disseldorp <ddiss@suse.de> wrote:

> Hi Saket Sinha,
>
> Thanks for your interest...
>
> On Wed, 4 Mar 2015 17:15:32 +0530, Saket Sinha wrote:
>
> > Hi,
> >
> > I am looking forward to paticipate in GSOC 2015 with Samba community for
> > Improving SMB3 protocol improvements.
> >
> > This is to discuss the idea further in order to build my understanding of
> > the project.
> >
> > The TODOs listed here show the following -
> >
> >    1. Support for using multiple network interfaces at once under the
> same
> >    mount (SMB3 multichannel)
> >    2. Improved directory and metadata caching ("directory oplocks")
> >    3. Improved failover in clustering environments ("persistent file
> >    handles" and more generally SMB3 "continuous availability" support)
> >    4. File copy offload (there are multiple server side copy mechanisms
> >    possible with SMB3, T10 copy offload, SMB2/SMB3 "copy chunk" as well
> as an
> >    older cifs mechanism "SMB Copy" that could be implemented, compared
> and
> >    optimized).
> >    5. HA availability improvements on server and/or client (the SMB3
> >    "Witness protocol")
> >
> >  I would like to be guided which one I should pick up to get started.
>
> These tasks all relate to the Linux kernel CIFS/SMB client (cifs.ko), so
> would be best answered on the cifs.ko mailing list (cc'ed). I'd suggest
> only pursuing these tasks if you have a reasonably solid background in C
> programming.
>
> Cheers, David
>
