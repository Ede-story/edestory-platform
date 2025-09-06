export default function HomePage() {
  return (
    <main className="min-h-screen p-8">
      <h1 className="text-4xl font-bold mb-4">Edestory Platform</h1>
      <p className="text-lg mb-8">Welcome to our B2B dropshipping platform</p>
      
      <nav className="space-y-4">
        <h2 className="text-2xl font-semibold">Navigation</h2>
        <ul className="list-disc list-inside space-y-2">
          <li><a href="/products" className="text-blue-600 hover:underline">Products</a></li>
          <li><a href="/about" className="text-blue-600 hover:underline">About Us</a></li>
          <li><a href="/contact" className="text-blue-600 hover:underline">Contact</a></li>
          <li><a href="/diary" className="text-blue-600 hover:underline">Diary</a></li>
        </ul>
      </nav>
      
      <section className="mt-12">
        <h2 className="text-2xl font-semibold mb-4">Featured Products</h2>
        <div className="grid grid-cols-3 gap-4">
          <div className="border p-4 rounded">
            <h3 className="font-bold">Product 1</h3>
            <p>Amazing product from Asia</p>
            <span className="text-green-600 font-bold">€99.99</span>
          </div>
          <div className="border p-4 rounded">
            <h3 className="font-bold">Product 2</h3>
            <p>High quality item</p>
            <span className="text-green-600 font-bold">€149.99</span>
          </div>
          <div className="border p-4 rounded">
            <h3 className="font-bold">Product 3</h3>
            <p>Best seller product</p>
            <span className="text-green-600 font-bold">€79.99</span>
          </div>
        </div>
      </section>
    </main>
  )
}