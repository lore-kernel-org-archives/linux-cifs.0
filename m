From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [CIFS] [PATCH] consistently use smb_buf_length as be32 for cifs
 (try 3)
Date: Thu, 17 Mar 2011 12:44:46 -0400
Message-ID: <20110317164446.GA26600@infradead.org>
References: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-cifs@vger.kernel.org,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
To: Steve French <smfrench@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <AANLkTimb8H=2hzNWUK_sQ=SMKhaQLrTQzA7ABiy_E4H5@mail.gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-Id: linux-cifs.vger.kernel.org

None of the other fields uses a wrapper, and the name is overly
confusing.  I'd suggest to just opencode the be32_add_cpu instead of
wrapping it.

