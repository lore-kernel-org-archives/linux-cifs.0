From: starlight@binnacle.cx
Subject: Re: question about CIFS client glitches
Date: Thu, 23 Sep 2010 06:59:09 -0400
Message-ID: <6.2.5.6.2.20100923065213.056b4a50@binnacle.cx>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
	<6.2.5.6.2.20100917193123.056b6f78@binnacle.cx>
	<20100918072502.73987a62@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: samba@lists.samba.org, Steve French <smfrench@gmail.com>,
	linux-cifs@vger.kernel.org
To: Jeff Layton <jlayton@samba.org>
Return-path: <samba-bounces@lists.samba.org>
In-Reply-To: <20100918072502.73987a62@corrin.poochiereds.net>
References: <6.2.5.6.2.20100916171408.03a0fcd8@flumedata.com>
	<AANLkTimDWbZF=DkmVLw96V3nZGggFfNm0Zv3FxfFX1BE@mail.gmail.com>
	<6.2.5.6.2.20100916195402.0573dcc0@binnacle.cx>
	<6.2.5.6.2.20100917193123.056b6f78@binnacle.cx>
	<20100918072502.73987a62@corrin.poochiereds.net>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba>,
	<mailto:samba-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba>
List-Post: <mailto:samba@lists.samba.org>
List-Help: <mailto:samba-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba>,
	<mailto:samba-request@lists.samba.org?subject=subscribe>
Sender: samba-bounces@lists.samba.org
Errors-To: samba-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

At 07:25 AM 9/18/2010 -0400, Jeff Layton wrote:
>On Fri, 17 Sep 2010 19:38:21 -0400
>starlight@binnacle.cx wrote:
>> 
>> In both versions it seems like hard-links work and symbolic
>> links fail
>
>That's expected. The core cifs protocol as implemented in windows
>doesn't support symlinks.

Ah, well then it's a good thing they're not needed for the
build tree I'm working with.  Good to know not to ever
look for the feature for Windows shares.

>You need unix extensions for that, or you may
>want to play with the "mfsymlinks" patches that Metze proposed 
>recently.

Eeeh no.  Every time I've ever worked with a vanilla
kernel I sank in the quicksand of bugs and crashes.
Not fun, no time for it.

>> And it appears that a 'pax -r' extraction followed by 'rm' for
>> selected files has some difficulty with CIFS 1.6x rendered
>> hard link in the mix.
>> 
>
>What sort of difficulty is it having?

As expressed in the original message, 'pax' archive with hard 
links restored, 'rm' command executed, tree doesn't match.  
Maybe the fact that the 'pax' archive is created with a

   find tree -print | sort -r | pax -wd

has something to do with it, causing the 'pax -r' to
do things that CIFS is not expecting.

I am giving up though.  Decided to build a new server and setup 
an IB link so that Samba works acceptably from Windows and the
files can stay on the Linux side of the fence.

-- 
To unsubscribe from this list go to the following URL and read the
instructions:  https://lists.samba.org/mailman/options/samba
