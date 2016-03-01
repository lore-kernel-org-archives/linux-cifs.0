From: Volker Lendecke <Volker.Lendecke@SerNet.DE>
Subject: Re: Interop Issue: SMB2+ async replies, and the kernel, Samba side
 fix enclosed.
Date: Tue, 1 Mar 2016 14:40:39 +0100
Message-ID: <20160301134039.GA21826@sernet.de>
References: <CAAPGDwLnp90t7wiRb_tw-Md0jv-8w0Ye66jNcsRNioganVe2xg@mail.gmail.com>
 <56CC591F.30205@samba.org>
 <1D07D524-6243-4DF5-BBEB-13EE3A2B62AE@samba.org>
 <CAAPGDwL-VsVmPzFFEM5nOAgFCz68a2KHWGAy9KH6ED5PD0vx_Q@mail.gmail.com>
 <20160224190408.GC16429@jra3>
Reply-To: Volker.Lendecke@SerNet.DE
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Steven French <sfrench@samba.org>, Stefan Metzmacher <metze@samba.org>,
 Ira Cooper <ira@wakeful.net>,
 Samba Technical <samba-technical@lists.samba.org>, linux-cifs@vger.kernel.org
To: Jeremy Allison <jra@samba.org>
Return-path: <samba-technical-bounces@lists.samba.org>
Content-Disposition: inline
In-Reply-To: <20160224190408.GC16429@jra3>
List-Unsubscribe: <https://lists.samba.org/mailman/options/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/samba-technical/>
List-Post: <mailto:samba-technical@lists.samba.org>
List-Help: <mailto:samba-technical-request@lists.samba.org?subject=help>
List-Subscribe: <https://lists.samba.org/mailman/listinfo/samba-technical>,
 <mailto:samba-technical-request@lists.samba.org?subject=subscribe>
Errors-To: samba-technical-bounces@lists.samba.org
Sender: "samba-technical" <samba-technical-bounces@lists.samba.org>
List-Id: linux-cifs.vger.kernel.org

On Wed, Feb 24, 2016 at 11:04:08AM -0800, Jeremy Allison wrote:
> Hmmm. We can only test this by causing a Windows read to
> take a long time. Any idea how to test this ? Does Win32
> have named pipes in the fs we could use for that ? If not
> we could test using a program that creates a \\pipe\named_pipe
> and then responds slowly... But I don't know if the
> timeout replies on np's are the same as in the filesystem.

Just use a USB2 stick.

Volker

-- 
SerNet GmbH, Bahnhofsallee 1b, 37081 Göttingen
phone: +49-551-370000-0, fax: +49-551-370000-9
AG Göttingen, HRB 2816, GF: Dr. Johannes Loxen
http://www.sernet.de, mailto:kontakt@sernet.de
