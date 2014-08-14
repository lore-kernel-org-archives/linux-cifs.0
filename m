From: Jeremy Allison <jra@samba.org>
Subject: Re: [PATCH][CIFS] Workaround MacOS server problem with SMB2.1 write
 response
Date: Thu, 14 Aug 2014 13:44:24 -0700
Message-ID: <20140814204424.GE325@samba2>
References: <CAH2r5msWAcy41S85b5eN5QBZSqwXDnQU07yHS0gnKE+zaaXw4A@mail.gmail.com>
 <20140814153015.030657f7@tlielax.poochiereds.net>
 <20140814193519.GB325@samba2>
 <CAH2r5muwftfpt2kjvf4fM78X6JZ5H-Kt415+Z2AojTDUkPrArA@mail.gmail.com>
 <20140814164014.36023859@tlielax.poochiereds.net>
Reply-To: Jeremy Allison <jra@samba.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Steve French <smfrench@gmail.com>, Jeremy Allison <jra@samba.org>,
	"linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	samba-technical <samba-technical@lists.samba.org>
To: Jeff Layton <jeff.layton@primarydata.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140814164014.36023859@tlielax.poochiereds.net>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

On Thu, Aug 14, 2014 at 04:40:14PM -0400, Jeff Layton wrote:
> 
> Failing here won't change the buffer allocation. That buffer has
> already been allocated, and the receive is complete at this point. So
> any "damage" has already been done.

Yep. You've got to have read the data to know it's too much !

> So, I just don't get why you'd bother with an arbitrary limit at all.
> The error checking is _simpler_ if you don't bother with this limit. Or
> am I missing something here?

Nope. The server has to deal with the same problem
as well. We just accept what the client sends inside
the NetBIOS length limit, and ignore anything after
the "useful" data within the packet.

Doesn't matter *what* is in the extra bits, code
data, whatever. We don't look at it.

Steve, what is the problem with just ignoring the
extra data ? If it offends you - log a warning
message is the rfc1001 length is too long and
ignore it.
