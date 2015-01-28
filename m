From: David Disseldorp <ddiss@suse.de>
Subject: Re: New ioctl - FSCTL_DUPLICATE_EXTENTS_TO_FILE
Date: Wed, 28 Jan 2015 19:22:03 +0100
Message-ID: <20150128192203.5dbb06ea@g21.suse.de>
References: <CAH2r5mu4zB08avnUSig5b-DGBekgOHVGoUYNNosOpvfAfOYBoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, samba-technical <samba-technical@lists.samba.org>, David Disseldorp <ddiss@samba.org>
To: Steve French <smfrench@gmail.com>
Return-path: <samba-technical-bounces@lists.samba.org>
In-Reply-To: <CAH2r5mu4zB08avnUSig5b-DGBekgOHVGoUYNNosOpvfAfOYBoA@mail.gmail.com>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>, <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Sender: samba-technical-bounces@lists.samba.org
Errors-To: samba-technical-bounces@lists.samba.org
List-Id: linux-cifs.vger.kernel.org

On Tue, 27 Jan 2015 12:23:55 -0600, Steve French wrote:

> Has anyone tried the new ioctl (MS-FSCC) defined in the most recent
> update.  See section 2.3.7
> 
> Looks interesting for a new variant of copy offload
> 
> "A new File System Control (FSCTL) has been added to support the new
> FSCTL_DUPLICATE_EXTENTS_TO_FILE operation in [MS-FSA]."

I haven't played with it yet, but from the [MS-FCC] 20150119 preview
doc it looks very similar to copy-chunk, with a few small differences:
- It's only supported on ReFS, which may indicate that it's implemented
  using COW clones.
- It takes a regular file handle for the source, instead of requiring a
  preliminary SRV_REQUEST_RESUME_KEY exchange.
- Only a single chunk can be duplicated per request, rather than
  multiple.
- Overlapping ranges are not supported.
- The length field is 64-bits wide, instead of 32.
- The response only carries the status code. This may imply there is no
  server-advertised limit to the length of the request, further
  indicating that it's COW based.

Time to start poking around with smbtorture :)

Cheers, David
