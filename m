From: Volker Lendecke <Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org>
Subject: Re: copy chunk preliminary results
Date: Thu, 21 Nov 2013 12:35:18 +0100
Message-ID: <E1VjSXZ-0048Ny-Lq@intern.SerNet.DE>
References: <CAH2r5mtoGCn-z_-Aetwaxxvn8bS19mexb7Rur3TE=RGipGCppQ@mail.gmail.com>
 <527771DA.1050701@draigBrady.com>
 <20131121114541.09f67b3f@plati.site>
 <20131121112044.GA26664@infradead.org>
Reply-To: Volker.Lendecke-PS7XAnAlDA+VvDNblw4Uiw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Disseldorp <ddiss-l3A5Bk7waGM@public.gmane.org>,
	P??draig Brady <P@draigBrady.com>,
	Steve French <smfrench-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>,
	samba-technical <samba-technical-w/Ol4Ecudpl8XjKLYN78aQ@public.gmane.org>,
	"linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-cifs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Return-path: <linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Date: Thu, 21 Nov 2013 12:35:18 +0100
Content-Disposition: inline
In-Reply-To: <20131121112044.GA26664-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-cifs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <linux-cifs.vger.kernel.org>

On Thu, Nov 21, 2013 at 03:20:44AM -0800, Christoph Hellwig wrote:
> So it's time folks finally get the damn copyfile system call in, use
> that for CIFS, NFS and co, as well as letting btrfs optimize it.

Has the splice discussion gone anywhere? Sorry for not
following fully, but having splice disk->disk work well
0-copy might have the additional effect that eventually we
get TCP->disk 0-copy.

Volker
